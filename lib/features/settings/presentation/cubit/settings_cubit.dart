import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:quest_game_manager/features/config/data/models/public_config_model.dart';
import 'package:quest_game_manager/features/config/domain/repositories/config_repository.dart';

/// Simple cubit for settings management.
@injectable
class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._configRepository) : super(const SettingsState());

  final ConfigRepository _configRepository;

  void setAutoRetry({required bool enabled}) {
    emit(state.copyWith(autoRetryEnabled: enabled));
  }

  void setNotificationsEnabled({required bool enabled}) {
    emit(state.copyWith(notificationsEnabled: enabled));
  }

  Future<void> clearCache() async {
    // TODO(user): Implement cache clearing
    emit(state.copyWith(cacheCleared: true));
    await Future<void>.delayed(const Duration(seconds: 1));
    emit(state.copyWith(cacheCleared: false));
  }

  Future<void> saveConfig(String jsonString) async {
    emit(state.copyWith(configSaveStatus: ConfigSaveStatus.loading, configSaveError: null));
    try {
      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
      final model = PublicConfigModel.fromJson(jsonMap);
      final entity = model.toEntity();

      final result = await _configRepository.saveConfig(entity);
      result.fold(
        (failure) => emit(state.copyWith(
          configSaveStatus: ConfigSaveStatus.failure,
          configSaveError: failure.userMessage,
        )),
        (_) => emit(state.copyWith(configSaveStatus: ConfigSaveStatus.success)),
      );
    } catch (e) {
      emit(state.copyWith(
        configSaveStatus: ConfigSaveStatus.failure,
        configSaveError: 'Invalid JSON: $e',
      ));
    }
  }

  void resetConfigSaveStatus() {
    emit(state.copyWith(configSaveStatus: ConfigSaveStatus.initial, configSaveError: null));
  }
}

enum ConfigSaveStatus { initial, loading, success, failure }

class SettingsState {
  const SettingsState({
    this.autoRetryEnabled = true,
    this.notificationsEnabled = true,
    this.cacheCleared = false,
    this.configSaveStatus = ConfigSaveStatus.initial,
    this.configSaveError,
  });

  final bool autoRetryEnabled;
  final bool notificationsEnabled;
  final bool cacheCleared;
  final ConfigSaveStatus configSaveStatus;
  final String? configSaveError;

  SettingsState copyWith({
    bool? autoRetryEnabled,
    bool? notificationsEnabled,
    bool? cacheCleared,
    ConfigSaveStatus? configSaveStatus,
    String? configSaveError,
  }) {
    return SettingsState(
      autoRetryEnabled: autoRetryEnabled ?? this.autoRetryEnabled,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      cacheCleared: cacheCleared ?? this.cacheCleared,
      configSaveStatus: configSaveStatus ?? this.configSaveStatus,
      configSaveError: configSaveError ?? this.configSaveError,
    );
  }
}

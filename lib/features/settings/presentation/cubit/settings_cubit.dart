import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:quest_game_manager/core/utils/file_utils.dart';
import 'package:quest_game_manager/features/config/data/models/public_config_model.dart';
import 'package:quest_game_manager/features/config/domain/repositories/config_repository.dart';
import 'package:quest_game_manager/features/downloads/domain/repositories/download_repository.dart';

/// Simple cubit for settings management.
@injectable
class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(
    this._configRepository,
    this._downloadRepository,
  ) : super(const SettingsState());

  final ConfigRepository _configRepository;
  final DownloadRepository _downloadRepository;

  void setAutoRetry({required bool enabled}) {
    emit(state.copyWith(autoRetryEnabled: enabled));
  }

  void setAutoInstall({required bool enabled}) {
    emit(state.copyWith(autoInstallEnabled: enabled));
  }

  Future<void> loadDownloadsSize() async {
    final result = await _downloadRepository.getDownloadsSize();
    result.fold(
      (_) => emit(state.copyWith(downloadsSize: 0)),
      (size) => emit(state.copyWith(downloadsSize: size)),
    );
  }

  Future<void> clearDownloads() async {
    emit(state.copyWith(clearingStatus: ClearingStatus.loading));
    final result = await _downloadRepository.clearDownloads();
    result.fold(
      (failure) => emit(state.copyWith(
        clearingStatus: ClearingStatus.failure,
        clearingError: failure.userMessage,
      )),
      (_) async {
        emit(state.copyWith(clearingStatus: ClearingStatus.success));
        await loadDownloadsSize();
        await Future<void>.delayed(const Duration(seconds: 1));
        emit(state.copyWith(clearingStatus: ClearingStatus.initial));
      },
    );
  }

  Future<void> clearCache() async {
    try {
      await FileUtils.clearCache();
      emit(state.copyWith(cacheCleared: true));
      await Future<void>.delayed(const Duration(seconds: 1));
      emit(state.copyWith(cacheCleared: false));
    } catch (_) {
      // Non-fatal
    }
  }

  Future<void> saveConfig(String jsonString) async {
    emit(state.copyWith(configSaveStatus: ConfigSaveStatus.loading));
    try {
      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
      final model = PublicConfigModel.fromJson(jsonMap);
      final entity = model.toEntity();

      final result = await _configRepository.saveConfig(entity);
      result.fold(
        (failure) => emit(
          state.copyWith(
            configSaveStatus: ConfigSaveStatus.failure,
            configSaveError: failure.userMessage,
          ),
        ),
        (_) => emit(state.copyWith(configSaveStatus: ConfigSaveStatus.success)),
      );
    } catch (e) {
      emit(
        state.copyWith(
          configSaveStatus: ConfigSaveStatus.failure,
          configSaveError: 'Invalid JSON format',
        ),
      );
    }
  }

  void resetConfigSaveStatus() {
    emit(state.copyWith(configSaveStatus: ConfigSaveStatus.initial));
  }
}

enum ConfigSaveStatus { initial, loading, success, failure }

enum ClearingStatus { initial, loading, success, failure }

class SettingsState {
  const SettingsState({
    this.autoRetryEnabled = true,
    this.autoInstallEnabled = true,
    this.cacheCleared = false,
    this.downloadsSize = 0,
    this.clearingStatus = ClearingStatus.initial,
    this.clearingError,
    this.configSaveStatus = ConfigSaveStatus.initial,
    this.configSaveError,
  });

  final bool autoRetryEnabled;
  final bool autoInstallEnabled;
  final bool cacheCleared;
  final int downloadsSize;
  final ClearingStatus clearingStatus;
  final String? clearingError;
  final ConfigSaveStatus configSaveStatus;
  final String? configSaveError;

  SettingsState copyWith({
    bool? autoRetryEnabled,
    bool? autoInstallEnabled,
    bool? cacheCleared,
    int? downloadsSize,
    ClearingStatus? clearingStatus,
    String? clearingError,
    ConfigSaveStatus? configSaveStatus,
    String? configSaveError,
  }) {
    return SettingsState(
      autoRetryEnabled: autoRetryEnabled ?? this.autoRetryEnabled,
      autoInstallEnabled: autoInstallEnabled ?? this.autoInstallEnabled,
      cacheCleared: cacheCleared ?? this.cacheCleared,
      downloadsSize: downloadsSize ?? this.downloadsSize,
      clearingStatus: clearingStatus ?? this.clearingStatus,
      clearingError: clearingError ?? this.clearingError,
      configSaveStatus: configSaveStatus ?? this.configSaveStatus,
      configSaveError: configSaveError ?? this.configSaveError,
    );
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

/// Simple cubit for settings management.
@injectable
class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsState());

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
}

class SettingsState {
  const SettingsState({
    this.autoRetryEnabled = true,
    this.notificationsEnabled = true,
    this.cacheCleared = false,
  });

  final bool autoRetryEnabled;
  final bool notificationsEnabled;
  final bool cacheCleared;

  SettingsState copyWith({bool? autoRetryEnabled, bool? notificationsEnabled, bool? cacheCleared}) {
    return SettingsState(
      autoRetryEnabled: autoRetryEnabled ?? this.autoRetryEnabled,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      cacheCleared: cacheCleared ?? this.cacheCleared,
    );
  }
}

import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:quest_game_manager/core/utils/app_logger.dart';
import 'package:quest_game_manager/features/catalog/domain/entities/game.dart';
import 'package:quest_game_manager/features/installer/data/datasources/installer_datasource.dart';
import 'package:quest_game_manager/features/installer/domain/repositories/installer_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'installer_bloc.freezed.dart';

// Events
@freezed
sealed class InstallerEvent with _$InstallerEvent {
  const factory InstallerEvent.install({
    required Game game,
    required String extractedDir,
  }) = InstallerInstall;
  const factory InstallerEvent.refreshInstalled() = InstallerRefreshInstalled;
  const factory InstallerEvent.uninstall(String packageName) = InstallerUninstall;
  const factory InstallerEvent.launch(String packageName) = InstallerLaunch;
}

// States
@freezed
sealed class InstallerState with _$InstallerState {
  const factory InstallerState.idle({
    @Default({}) Set<String> installedPackages,
  }) = InstallerIdle;
  const factory InstallerState.installing({
    required String gameName,
    required InstallStage stage,
    required Set<String> installedPackages,
  }) = InstallerInstalling;
  const factory InstallerState.success({
    required String gameName,
    required Set<String> installedPackages,
  }) = InstallerSuccess;
  const factory InstallerState.failed({
    required String message,
    required Set<String> installedPackages,
  }) = InstallerFailed;
}

enum InstallStage { findingApk, installingApk, copyingObb, cleaning, done }

@injectable
class InstallerBloc extends Bloc<InstallerEvent, InstallerState> {
  InstallerBloc(this._repository, this._datasource)
      : super(const InstallerState.idle()) {
    on<InstallerInstall>(_onInstall);
    on<InstallerRefreshInstalled>(_onRefreshInstalled);
    on<InstallerUninstall>(_onUninstall);
    on<InstallerLaunch>(_onLaunch);
  }

  final InstallerRepository _repository;
  final InstallerDatasource _datasource;

  /// Maps packageName -> installed version code. Populated during refreshInstalled.
  final Map<String, int> installedVersions = {};

  Set<String> get _currentInstalled => switch (state) {
        InstallerIdle(:final installedPackages) => installedPackages,
        InstallerInstalling(:final installedPackages) => installedPackages,
        InstallerSuccess(:final installedPackages) => installedPackages,
        InstallerFailed(:final installedPackages) => installedPackages,
      };

  Future<void> _onInstall(InstallerInstall event, Emitter<InstallerState> emit) async {
    final game = event.game;
    final extractedDir = event.extractedDir;

    // Stage 1: Find APK
    emit(InstallerState.installing(
      gameName: game.name,
      stage: InstallStage.findingApk,
      installedPackages: _currentInstalled,
    ));

    final dir = Directory(extractedDir);
    if (!await dir.exists()) {
      emit(InstallerState.failed(
        message: 'Extracted directory not found',
        installedPackages: _currentInstalled,
      ));
      return;
    }

    // Find APK files recursively
    final apkFiles = <File>[];
    await for (final entity in dir.list(recursive: true)) {
      if (entity is File && entity.path.endsWith('.apk')) {
        apkFiles.add(entity);
      }
    }

    if (apkFiles.isEmpty) {
      emit(InstallerState.failed(
        message: 'No APK file found in extracted data',
        installedPackages: _currentInstalled,
      ));
      return;
    }

    // Stage 2: Install APK
    emit(InstallerState.installing(
      gameName: game.name,
      stage: InstallStage.installingApk,
      installedPackages: _currentInstalled,
    ));

    for (final apk in apkFiles) {
      AppLogger.info('Installing APK: ${apk.path}', tag: 'InstallerBloc');
      final result = await _repository.installApk(apk.path);
      final failed = result.fold(
        (failure) {
          AppLogger.error('APK install failed: ${failure.userMessage}', tag: 'InstallerBloc');
          return true;
        },
        (success) => !success,
      );
      if (failed) {
        emit(InstallerState.failed(
          message: 'Failed to install ${apk.uri.pathSegments.last}',
          installedPackages: _currentInstalled,
        ));
        return;
      }
    }

    // Stage 3: Copy OBB files
    emit(InstallerState.installing(
      gameName: game.name,
      stage: InstallStage.copyingObb,
      installedPackages: _currentInstalled,
    ));

    await _repository.copyObbFiles(extractedDir, game.packageName);

    // Stage 4: Cleanup
    emit(InstallerState.installing(
      gameName: game.name,
      stage: InstallStage.cleaning,
      installedPackages: _currentInstalled,
    ));

    await _repository.cleanup(extractedDir);

    // Done - refresh installed packages
    final updated = Set<String>.from(_currentInstalled)..add(game.packageName);
    emit(InstallerState.success(
      gameName: game.name,
      installedPackages: updated,
    ));
  }

  Future<void> _onRefreshInstalled(
    InstallerRefreshInstalled event,
    Emitter<InstallerState> emit,
  ) async {
    final result = await _repository.getInstalledPackages();
    result.fold(
      (failure) => AppLogger.error('Failed to get installed: ${failure.userMessage}',
          tag: 'InstallerBloc'),
      (packages) {
        final installed = packages.toSet();
        emit(InstallerState.idle(installedPackages: installed));
      },
    );
    // Fetch version info for installed packages
    for (final pkg in _currentInstalled) {
      try {
        final version = await _datasource.getInstalledVersion(pkg);
        if (version > 0) installedVersions[pkg] = version;
      } catch (_) {}
    }
  }

  Future<void> _onUninstall(InstallerUninstall event, Emitter<InstallerState> emit) async {
    await _datasource.uninstallPackage(event.packageName);
  }

  Future<void> _onLaunch(InstallerLaunch event, Emitter<InstallerState> emit) async {
    await _datasource.launchPackage(event.packageName);
  }
}

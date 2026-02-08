// ignore_for_file: avoid_slow_async_io

import 'dart:io';

import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:quest_game_manager/core/constants/app_constants.dart';
import 'package:quest_game_manager/core/utils/app_logger.dart';

/// Platform channel wrapper for APK installation and package management.
@lazySingleton
class InstallerDatasource {
  static const _channel = MethodChannel(AppConstants.installerChannel);

  /// Installs an APK file using Android PackageInstaller API.
  Future<Map<String, dynamic>> installApk(String apkPath) async {
    AppLogger.info('Installing APK: $apkPath', tag: 'InstallerDS');
    try {
      final result = await _channel.invokeMethod<Map<Object?, Object?>>(
        'installApk',
        {'apkPath': apkPath},
      );
      if (result != null) {
        return result.map((k, v) => MapEntry(k.toString(), v));
      }
      return {'success': false, 'message': 'No result from installer'};
    } on PlatformException catch (e) {
      AppLogger.error('Install failed: ${e.message}', tag: 'InstallerDS');
      return {'success': false, 'message': e.message ?? 'Installation failed'};
    }
  }

  /// Checks if the app has permission to install packages.
  Future<bool> canInstallPackages() async {
    try {
      final result = await _channel.invokeMethod<bool>('canInstallPackages');
      return result ?? false;
    } catch (e) {
      AppLogger.error('canInstallPackages check failed', tag: 'InstallerDS', error: e);
      return false;
    }
  }

  /// Gets list of all installed packages.
  Future<List<Map<String, dynamic>>> getInstalledPackages() async {
    try {
      final result = await _channel.invokeMethod<List<Object?>>('getInstalledPackages');
      if (result == null) return [];
      return result
          .whereType<Map<Object?, Object?>>()
          .map((m) => m.map((k, v) => MapEntry(k.toString(), v)))
          .toList();
    } catch (e) {
      AppLogger.error('getInstalledPackages failed', tag: 'InstallerDS', error: e);
      return [];
    }
  }

  /// Checks if a specific package is installed.
  Future<bool> isPackageInstalled(String packageName) async {
    try {
      final result = await _channel.invokeMethod<bool>(
        'isPackageInstalled',
        {'packageName': packageName},
      );
      return result ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Gets the installed version code for a package.
  Future<int> getInstalledVersion(String packageName) async {
    try {
      final result = await _channel.invokeMethod<int>(
        'getInstalledVersion',
        {'packageName': packageName},
      );
      return result ?? -1;
    } catch (e) {
      return -1;
    }
  }

  /// Triggers uninstall dialog for a package.
  Future<void> uninstallPackage(String packageName) async {
    try {
      await _channel.invokeMethod<bool>(
        'uninstallPackage',
        {'packageName': packageName},
      );
    } catch (e) {
      AppLogger.error('uninstallPackage failed', tag: 'InstallerDS', error: e);
    }
  }

  /// Launches an installed package.
  Future<bool> launchPackage(String packageName) async {
    try {
      final result = await _channel.invokeMethod<bool>(
        'launchPackage',
        {'packageName': packageName},
      );
      return result ?? false;
    } catch (e) {
      AppLogger.error('launchPackage failed', tag: 'InstallerDS', error: e);
      return false;
    }
  }

  /// Copies OBB files from source directory to the Android OBB directory.
  /// Searches recursively for .obb files to handle varying archive structures.
  Future<void> copyObbFiles(String sourceDir, String packageName) async {
    // First try the conventional path: sourceDir/packageName/
    final obbSourceDir = Directory('$sourceDir/$packageName');

    // Collect all OBB files - search recursively in the whole sourceDir
    final obbFiles = <File>[];
    final searchDir = Directory(sourceDir);
    if (!await searchDir.exists()) {
      AppLogger.debug('Source directory not found: $sourceDir', tag: 'InstallerDS');
      return;
    }

    await for (final entity in searchDir.list(recursive: true)) {
      if (entity is File && entity.path.endsWith('.obb')) {
        obbFiles.add(entity);
      }
    }

    // Also copy non-APK, non-OBB data files from the package subdirectory
    if (await obbSourceDir.exists()) {
      await for (final entity in obbSourceDir.list(recursive: true)) {
        if (entity is File && !entity.path.endsWith('.obb') && !entity.path.endsWith('.apk')) {
          obbFiles.add(entity);
        }
      }
    }

    if (obbFiles.isEmpty) {
      AppLogger.debug('No OBB/data files found for $packageName', tag: 'InstallerDS');
      return;
    }

    final obbTargetDir = Directory('${AppConstants.obbBasePath}/$packageName');

    // Remove existing OBB directory
    if (await obbTargetDir.exists()) {
      await obbTargetDir.delete(recursive: true);
    }
    await obbTargetDir.create(recursive: true);

    // Copy all OBB/data files
    for (final file in obbFiles) {
      final fileName = file.uri.pathSegments.last;
      final targetPath = '${obbTargetDir.path}/$fileName';
      AppLogger.info('Copying OBB/data: $fileName', tag: 'InstallerDS');
      await file.copy(targetPath);
    }
    AppLogger.info('OBB files copied for $packageName (${obbFiles.length} files)', tag: 'InstallerDS');
  }
}

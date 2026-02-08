// ignore_for_file: avoid_slow_async_io

import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:quest_game_manager/core/error/failures.dart';
import 'package:quest_game_manager/core/utils/app_logger.dart';
import 'package:quest_game_manager/features/installer/data/datasources/installer_datasource.dart';
import 'package:quest_game_manager/features/installer/domain/repositories/installer_repository.dart';

/// Implementation of InstallerRepository using platform channels.
@LazySingleton(as: InstallerRepository)
class InstallerRepositoryImpl implements InstallerRepository {
  InstallerRepositoryImpl(this._datasource);
  final InstallerDatasource _datasource;

  @override
  Future<Either<Failure, String>> extractGame(
    String archivePath,
    String outputDir,
    String password,
  ) async {
    // Extraction is handled by the archive platform channel, not here.
    // This method is kept for interface compliance.
    return Right(outputDir);
  }

  @override
  Future<Either<Failure, bool>> installApk(String apkPath) async {
    try {
      final result = await _datasource.installApk(apkPath);
      final success = result['success'] as bool? ?? false;
      if (success) {
        return const Right(true);
      }
      final message = result['message'] as String? ?? 'Unknown error';
      return Left(InstallationFailure(message: message));
    } catch (e) {
      return Left(InstallationFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> copyObbFiles(String sourceDir, String packageName) async {
    try {
      await _datasource.copyObbFiles(sourceDir, packageName);
      return const Right(null);
    } catch (e) {
      return Left(StorageFailure(message: 'Failed to copy OBB files: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> cleanup(String directory) async {
    try {
      final dir = Directory(directory);
      if (await dir.exists()) {
        await dir.delete(recursive: true);
      }
      return const Right(null);
    } catch (e) {
      AppLogger.warning('Cleanup failed: $e', tag: 'InstallerRepo');
      return const Right(null); // Non-fatal
    }
  }

  @override
  Future<Either<Failure, bool>> canInstallPackages() async {
    try {
      final can = await _datasource.canInstallPackages();
      return Right(can);
    } catch (e) {
      return const Left(PermissionFailure(permission: 'INSTALL_PACKAGES'));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getInstalledPackages() async {
    try {
      final packages = await _datasource.getInstalledPackages();
      return Right(packages.map((p) => p['packageName'] as String).toList());
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}

import 'package:fpdart/fpdart.dart';
import 'package:quest_game_manager/core/error/failures.dart';

/// Repository interface for installation operations.
abstract class InstallerRepository {
  Future<Either<Failure, String>> extractGame(
    String archivePath,
    String outputDir,
    String password,
  );
  Future<Either<Failure, bool>> installApk(String apkPath);
  Future<Either<Failure, void>> copyObbFiles(String sourceDir, String packageName);
  Future<Either<Failure, void>> cleanup(String directory);
  Future<Either<Failure, bool>> canInstallPackages();
  Future<Either<Failure, List<String>>> getInstalledPackages();
}

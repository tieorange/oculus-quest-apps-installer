import 'package:hive/hive.dart';
import 'package:quest_game_manager/features/catalog/domain/entities/game.dart';

part 'game_info_model.g.dart';

/// Data model for game info with Hive support.
@HiveType(typeId: 0)
class GameInfoModel extends HiveObject {
  GameInfoModel({
    required this.name,
    required this.releaseName,
    required this.packageName,
    required this.versionCode,
    required this.lastUpdated,
    required this.sizeMb,
  });

  factory GameInfoModel.fromCsvLine(String line) {
    final parts = line.split(';');
    if (parts.length < 6) {
      throw const FormatException('Invalid game list line');
    }
    return GameInfoModel(
      name: parts[0].trim(),
      releaseName: parts[1].trim(),
      packageName: parts[2].trim(),
      versionCode: parts[3].trim(),
      lastUpdated: parts[4].trim(),
      sizeMb: parts[5].trim(),
    );
  }

  factory GameInfoModel.fromEntity(Game game) => GameInfoModel(
        name: game.name,
        releaseName: game.releaseName,
        packageName: game.packageName,
        versionCode: game.versionCode,
        lastUpdated: game.lastUpdated,
        sizeMb: game.sizeMb,
      );

  @HiveField(0)
  final String name;

  @HiveField(1)
  final String releaseName;

  @HiveField(2)
  final String packageName;

  @HiveField(3)
  final String versionCode;

  @HiveField(4)
  final String lastUpdated;

  @HiveField(5)
  final String sizeMb;

  Game toEntity() => Game(
        name: name,
        releaseName: releaseName,
        packageName: packageName,
        versionCode: versionCode,
        lastUpdated: lastUpdated,
        sizeMb: sizeMb,
      );
}

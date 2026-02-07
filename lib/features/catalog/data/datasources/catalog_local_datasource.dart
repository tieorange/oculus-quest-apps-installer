import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:quest_game_manager/features/catalog/data/models/game_info_model.dart';

/// Local data source for caching game catalog.
@lazySingleton
class CatalogLocalDatasource {
  static const String _boxName = 'games_cache';

  Future<Box<GameInfoModel>> _getBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return Hive.openBox<GameInfoModel>(_boxName);
    }
    return Hive.box<GameInfoModel>(_boxName);
  }

  Future<List<GameInfoModel>> getCachedGames() async {
    final box = await _getBox();
    return box.values.toList();
  }

  Future<void> cacheGames(List<GameInfoModel> games) async {
    final box = await _getBox();
    await box.clear();
    for (final game in games) {
      await box.put(game.packageName, game);
    }
  }

  Future<bool> hasCachedData() async {
    final box = await _getBox();
    return box.isNotEmpty;
  }
}

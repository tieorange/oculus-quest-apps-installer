import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:quest_game_manager/features/catalog/data/models/cache_meta_model.dart';
import 'package:quest_game_manager/features/catalog/data/models/game_info_model.dart';

/// Local data source for caching game catalog.
@lazySingleton
class CatalogLocalDatasource {
  static const String _boxName = 'games_cache';
  static const String _metaBoxName = 'cache_meta';
  static const String _metaKey = 'catalog_meta';

  Future<Box<GameInfoModel>> _getBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return Hive.openBox<GameInfoModel>(_boxName);
    }
    return Hive.box<GameInfoModel>(_boxName);
  }

  Future<Box<CacheMetaModel>> _getMetaBox() async {
    if (!Hive.isBoxOpen(_metaBoxName)) {
      return Hive.openBox<CacheMetaModel>(_metaBoxName);
    }
    return Hive.box<CacheMetaModel>(_metaBoxName);
  }

  Future<List<GameInfoModel>> getCachedGames() async {
    final box = await _getBox();
    return box.values.toList();
  }

  Future<void> cacheGames(List<GameInfoModel> games) async {
    final box = await _getBox();
    await box.clear();
    final gameMap = {for (final game in games) game.packageName: game};
    await box.putAll(gameMap);

    // Update cache metadata with timestamp
    await _updateCacheMeta(games.length);
  }

  Future<void> _updateCacheMeta(int gameCount) async {
    final metaBox = await _getMetaBox();
    final meta = CacheMetaModel(
      lastUpdated: DateTime.now(),
      gameCount: gameCount,
    );
    await metaBox.put(_metaKey, meta);
  }

  /// Returns the timestamp of when the cache was last updated.
  /// Returns null if no cache exists.
  Future<DateTime?> getCacheAge() async {
    final metaBox = await _getMetaBox();
    final meta = metaBox.get(_metaKey);
    return meta?.lastUpdated;
  }

  Future<bool> hasCachedData() async {
    final box = await _getBox();
    return box.isNotEmpty;
  }
}

import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:quest_game_manager/core/constants/app_constants.dart';

@lazySingleton
class FavoritesLocalDatasource {
  Box<String>? _box;

  Future<Box<String>> get _favoritesBox async {
    _box ??= await Hive.openBox<String>(AppConstants.favoritesBoxName);
    return _box!;
  }

  Future<Set<String>> getFavorites() async {
    final box = await _favoritesBox;
    return box.values.toSet();
  }

  Future<void> addFavorite(String packageName) async {
    final box = await _favoritesBox;
    await box.put(packageName, packageName);
  }

  Future<void> removeFavorite(String packageName) async {
    final box = await _favoritesBox;
    await box.delete(packageName);
  }

  Future<bool> isFavorite(String packageName) async {
    final box = await _favoritesBox;
    return box.containsKey(packageName);
  }
}

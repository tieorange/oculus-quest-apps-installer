import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:quest_game_manager/core/utils/app_logger.dart';
import 'package:quest_game_manager/features/favorites/data/datasources/favorites_local_datasource.dart';

@injectable
class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit(this._datasource) : super(const FavoritesState());

  final FavoritesLocalDatasource _datasource;

  Future<void> loadFavorites() async {
    try {
      final favorites = await _datasource.getFavorites();
      emit(FavoritesState(favorites: favorites));
    } catch (e) {
      AppLogger.error('Failed to load favorites', tag: 'FavoritesCubit', error: e);
    }
  }

  Future<void> toggleFavorite(String packageName) async {
    try {
      if (state.favorites.contains(packageName)) {
        await _datasource.removeFavorite(packageName);
        emit(FavoritesState(favorites: {...state.favorites}..remove(packageName)));
      } else {
        await _datasource.addFavorite(packageName);
        emit(FavoritesState(favorites: {...state.favorites, packageName}));
      }
    } catch (e) {
      AppLogger.error('Failed to toggle favorite', tag: 'FavoritesCubit', error: e);
    }
  }

  bool isFavorite(String packageName) => state.favorites.contains(packageName);
}

class FavoritesState {
  const FavoritesState({this.favorites = const {}});
  final Set<String> favorites;
}

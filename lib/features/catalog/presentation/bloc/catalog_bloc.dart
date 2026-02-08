import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:quest_game_manager/core/usecases/usecase.dart';
import 'package:quest_game_manager/features/catalog/domain/entities/game.dart';
import 'package:quest_game_manager/features/catalog/domain/usecases/get_game_catalog.dart';
import 'package:quest_game_manager/features/catalog/domain/usecases/search_games.dart';
import 'package:quest_game_manager/features/catalog/presentation/bloc/catalog_event.dart';
import 'package:quest_game_manager/features/catalog/presentation/bloc/catalog_state.dart';
import 'package:quest_game_manager/features/config/domain/usecases/fetch_config.dart';

/// BLoC for managing game catalog state.
@injectable
class CatalogBloc extends Bloc<CatalogEvent, CatalogState> {
  CatalogBloc(this._fetchConfig, this._getGameCatalog, this._searchGames)
    : super(const CatalogState.initial()) {
    on<CatalogLoad>(_onLoad);
    on<CatalogRefresh>(_onRefresh);
    on<CatalogSearch>(_onSearch);
    on<CatalogFilterByStatus>(_onFilter);
    on<CatalogSortBy>(_onSort);
  }

  final FetchConfig _fetchConfig;
  final GetGameCatalog _getGameCatalog;
  final SearchGames _searchGames;

  Future<void> _onLoad(CatalogLoad event, Emitter<CatalogState> emit) async {
    emit(const CatalogState.loading());
    await _loadCatalog(emit);
  }

  Future<void> _onRefresh(CatalogRefresh event, Emitter<CatalogState> emit) async {
    final currentState = state;
    if (currentState is! CatalogLoaded) {
      emit(const CatalogState.loading());
    }
    await _loadCatalog(emit);
  }

  Future<void> _loadCatalog(Emitter<CatalogState> emit) async {
    final configResult = await _fetchConfig(const NoParams());

    await configResult.fold((failure) async => emit(CatalogState.error(failure)), (config) async {
      final catalogResult = await _getGameCatalog(config);
      catalogResult.fold(
        (failure) => emit(CatalogState.error(failure)),
        (games) => emit(
          CatalogState.loaded(
            games: games,
            filteredGames: _sortGames(games, SortType.lastUpdated),
            searchQuery: '',
            sortType: SortType.lastUpdated,
            filter: GameStatusFilter.all,
            installedPackages: const {},
          ),
        ),
      );
    });
  }

  void _onSearch(CatalogSearch event, Emitter<CatalogState> emit) {
    final currentState = state;
    if (currentState is CatalogLoaded) {
      final filtered = _searchGames(currentState.games, event.query);
      final sorted = _sortGames(filtered, currentState.sortType);
      emit(currentState.copyWith(filteredGames: sorted, searchQuery: event.query));
    }
  }

  void _onFilter(CatalogFilterByStatus event, Emitter<CatalogState> emit) {
    final currentState = state;
    if (currentState is CatalogLoaded) {
      final filtered = _applyFilters(
        currentState.games,
        event.filter,
        currentState.installedPackages,
        currentState.searchQuery,
      );
      emit(
        currentState.copyWith(
          filteredGames: _sortGames(filtered, currentState.sortType),
          filter: event.filter,
        ),
      );
    }
  }

  void _onSort(CatalogSortBy event, Emitter<CatalogState> emit) {
    final currentState = state;
    if (currentState is CatalogLoaded) {
      emit(
        currentState.copyWith(
          filteredGames: _sortGames(currentState.filteredGames, event.sortType),
          sortType: event.sortType,
        ),
      );
    }
  }

  List<Game> _sortGames(List<Game> games, SortType sortType) {
    final sorted = List<Game>.from(games);
    switch (sortType) {
      case SortType.name:
        sorted.sort((a, b) => a.name.compareTo(b.name));
      case SortType.nameDesc:
        sorted.sort((a, b) => b.name.compareTo(a.name));
      case SortType.lastUpdated:
        sorted.sort((a, b) => b.lastUpdated.compareTo(a.lastUpdated));
      case SortType.size:
        sorted.sort((a, b) => b.sizeInMb.compareTo(a.sizeInMb));
    }
    return sorted;
  }

  List<Game> _applyFilters(
    List<Game> games,
    GameStatusFilter filter,
    Set<String> installed,
    String query,
  ) {
    var filtered = _searchGames(games, query);
    switch (filter) {
      case GameStatusFilter.all:
        break;
      case GameStatusFilter.installed:
        filtered = filtered.where((g) => installed.contains(g.packageName)).toList();
      case GameStatusFilter.notInstalled:
        filtered = filtered.where((g) => !installed.contains(g.packageName)).toList();
    }
    return filtered;
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:quest_game_manager/core/usecases/usecase.dart';
import 'package:quest_game_manager/core/utils/app_logger.dart';
import 'package:quest_game_manager/features/catalog/domain/entities/game.dart';
import 'package:quest_game_manager/features/catalog/domain/usecases/get_game_catalog.dart';
import 'package:quest_game_manager/features/catalog/domain/usecases/search_games.dart';
import 'package:quest_game_manager/features/catalog/presentation/bloc/catalog_event.dart';
import 'package:quest_game_manager/features/catalog/presentation/bloc/catalog_state.dart';
import 'package:quest_game_manager/features/config/domain/usecases/fetch_config.dart';

/// BLoC for managing game catalog state with stale-while-revalidate caching.
@injectable
class CatalogBloc extends Bloc<CatalogEvent, CatalogState> {
  CatalogBloc(
    this._fetchConfig,
    this._getGameCatalog,
    this._getCachedCatalog,
    this._isCacheStale,
    this._searchGames,
  ) : super(const CatalogState.initial()) {
    on<CatalogLoad>(_onLoad);
    on<CatalogRefresh>(_onRefresh);
    on<CatalogSearch>(_onSearch);
    on<CatalogFilterByStatus>(_onFilterByStatus);
    on<CatalogFilterBySize>(_onFilterBySize);
    on<CatalogFilterByRecency>(_onFilterByRecency);
    on<CatalogSortBy>(_onSort);
    on<CatalogUpdateGames>(_onUpdateGames);
    on<CatalogClearFilters>(_onClearFilters);
  }

  final FetchConfig _fetchConfig;
  final GetGameCatalog _getGameCatalog;
  final GetCachedCatalog _getCachedCatalog;
  final IsCacheStale _isCacheStale;
  final SearchGames _searchGames;

  /// Stale-while-revalidate pattern:
  /// 1. Show cached data immediately (if available)
  /// 2. If cache is stale, refresh in background with loading indicator
  /// 3. Update UI seamlessly when fresh data arrives
  Future<void> _onLoad(CatalogLoad event, Emitter<CatalogState> emit) async {
    AppLogger.info('Loading catalog with stale-while-revalidate', tag: 'CatalogBloc');

    // 1. Try to load cached data first
    final cachedResult = await _getCachedCatalog();
    final cachedGames = cachedResult.fold((_) => <Game>[], (games) => games);

    if (cachedGames.isNotEmpty) {
      // Show cached data immediately
      AppLogger.info('Showing ${cachedGames.length} cached games', tag: 'CatalogBloc');
      emit(
        CatalogState.loaded(
          games: cachedGames,
          filteredGames: _sortGames(cachedGames, SortType.lastUpdated),
          searchQuery: '',
          sortType: SortType.lastUpdated,
          statusFilter: GameStatusFilter.all,
          installedPackages: const {},
          isRefreshing: true, // Show loading indicator
        ),
      );
    } else {
      // No cache, show full loading state
      emit(const CatalogState.loading());
    }

    // 2. Check if cache is stale
    final isStale = await _isCacheStale();

    if (isStale || cachedGames.isEmpty) {
      AppLogger.info('Cache is stale, fetching fresh data', tag: 'CatalogBloc');
      await _fetchFreshData(emit);
    } else {
      // Cache is fresh, just remove the refreshing indicator
      final currentState = state;
      if (currentState is CatalogLoaded) {
        emit(currentState.copyWith(isRefreshing: false));
      }
    }
  }

  /// Force refresh from remote, keeping existing data visible.
  Future<void> _onRefresh(CatalogRefresh event, Emitter<CatalogState> emit) async {
    final currentState = state;
    if (currentState is CatalogLoaded) {
      // Show refreshing indicator while keeping data visible
      emit(currentState.copyWith(isRefreshing: true));
    } else {
      emit(const CatalogState.loading());
    }
    await _fetchFreshData(emit);
  }

  /// Fetches fresh data from remote and updates state.
  Future<void> _fetchFreshData(Emitter<CatalogState> emit) async {
    final configResult = await _fetchConfig(const NoParams());

    await configResult.fold(
      (failure) async {
        final currentState = state;
        if (currentState is CatalogLoaded && currentState.games.isNotEmpty) {
          // Keep showing cached data, just remove refreshing indicator
          AppLogger.warning('Refresh failed, keeping cached data', tag: 'CatalogBloc');
          emit(currentState.copyWith(isRefreshing: false));
        } else {
          emit(CatalogState.error(failure));
        }
      },
      (config) async {
        final catalogResult = await _getGameCatalog(config);
        catalogResult.fold(
          (failure) {
            final currentState = state;
            if (currentState is CatalogLoaded && currentState.games.isNotEmpty) {
              // Keep showing cached data, just remove refreshing indicator
              AppLogger.warning('Fetch failed, keeping cached data', tag: 'CatalogBloc');
              emit(currentState.copyWith(isRefreshing: false));
            } else {
              emit(CatalogState.error(failure));
            }
          },
          (games) {
            AppLogger.info('Loaded ${games.length} fresh games', tag: 'CatalogBloc');
            final currentState = state;
            if (currentState is CatalogLoaded) {
              // Update with fresh data, preserving sort/filter/search
              final filtered = _applyAllFilters(games, currentState);
              emit(
                currentState.copyWith(
                  games: games,
                  filteredGames: _sortGames(filtered, currentState.sortType),
                  isRefreshing: false,
                ),
              );
            } else {
              emit(
                CatalogState.loaded(
                  games: games,
                  filteredGames: _sortGames(games, SortType.lastUpdated),
                  searchQuery: '',
                  sortType: SortType.lastUpdated,
                  statusFilter: GameStatusFilter.all,
                  installedPackages: const {},
                ),
              );
            }
          },
        );
      },
    );
  }

  /// Handle external game list updates (e.g., from background refresh).
  void _onUpdateGames(CatalogUpdateGames event, Emitter<CatalogState> emit) {
    final currentState = state;
    if (currentState is CatalogLoaded) {
      final filtered = _applyAllFilters(event.games, currentState);
      emit(
        currentState.copyWith(
          games: event.games,
          filteredGames: _sortGames(filtered, currentState.sortType),
          isRefreshing: false,
        ),
      );
    }
  }

  void _onSearch(CatalogSearch event, Emitter<CatalogState> emit) {
    final currentState = state;
    if (currentState is CatalogLoaded) {
      final newState = currentState.copyWith(searchQuery: event.query);
      final filtered = _applyAllFilters(currentState.games, newState as CatalogLoaded);
      emit(newState.copyWith(filteredGames: _sortGames(filtered, currentState.sortType)));
    }
  }

  void _onFilterByStatus(CatalogFilterByStatus event, Emitter<CatalogState> emit) {
    final currentState = state;
    if (currentState is CatalogLoaded) {
      final newState = currentState.copyWith(statusFilter: event.filter);
      final filtered = _applyAllFilters(currentState.games, newState as CatalogLoaded);
      emit(newState.copyWith(filteredGames: _sortGames(filtered, currentState.sortType)));
    }
  }

  void _onFilterBySize(CatalogFilterBySize event, Emitter<CatalogState> emit) {
    final currentState = state;
    if (currentState is CatalogLoaded) {
      final newState = currentState.copyWith(sizeFilter: event.sizeFilter);
      final filtered = _applyAllFilters(currentState.games, newState as CatalogLoaded);
      emit(newState.copyWith(filteredGames: _sortGames(filtered, currentState.sortType)));
    }
  }

  void _onFilterByRecency(CatalogFilterByRecency event, Emitter<CatalogState> emit) {
    final currentState = state;
    if (currentState is CatalogLoaded) {
      final newState = currentState.copyWith(recencyFilter: event.recencyFilter);
      final filtered = _applyAllFilters(currentState.games, newState as CatalogLoaded);
      emit(newState.copyWith(filteredGames: _sortGames(filtered, currentState.sortType)));
    }
  }

  void _onClearFilters(CatalogClearFilters event, Emitter<CatalogState> emit) {
    final currentState = state;
    if (currentState is CatalogLoaded) {
      final sorted = _sortGames(currentState.games, SortType.lastUpdated);
      emit(
        currentState.copyWith(
          filteredGames: sorted,
          searchQuery: '',
          sortType: SortType.lastUpdated,
          statusFilter: GameStatusFilter.all,
          sizeFilter: SizeFilter.all,
          recencyFilter: RecencyFilter.all,
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
      case SortType.nameDescending:
        sorted.sort((a, b) => b.name.compareTo(a.name));
      case SortType.lastUpdated:
        sorted.sort((a, b) => b.lastUpdated.compareTo(a.lastUpdated));
      case SortType.size:
        sorted.sort((a, b) => b.sizeInMb.compareTo(a.sizeInMb));
      case SortType.sizeAscending:
        sorted.sort((a, b) => a.sizeInMb.compareTo(b.sizeInMb));
    }
    return sorted;
  }

  /// Apply all filters (search, status, size, recency) to games.
  List<Game> _applyAllFilters(List<Game> games, CatalogLoaded state) {
    var filtered = _searchGames(games, state.searchQuery);

    // Status filter
    filtered = _applyStatusFilter(filtered, state.statusFilter, state.installedPackages);

    // Size filter
    filtered = _applySizeFilter(filtered, state.sizeFilter);

    // Recency filter
    filtered = _applyRecencyFilter(filtered, state.recencyFilter);

    return filtered;
  }

  List<Game> _applyStatusFilter(
    List<Game> games,
    GameStatusFilter filter,
    Set<String> installed,
  ) {
    switch (filter) {
      case GameStatusFilter.all:
        return games;
      case GameStatusFilter.installed:
        return games.where((g) => installed.contains(g.packageName)).toList();
      case GameStatusFilter.notInstalled:
        return games.where((g) => !installed.contains(g.packageName)).toList();
    }
  }

  List<Game> _applySizeFilter(List<Game> games, SizeFilter filter) {
    switch (filter) {
      case SizeFilter.all:
        return games;
      case SizeFilter.small:
        return games.where((g) => g.sizeInMb < 500).toList();
      case SizeFilter.medium:
        return games.where((g) => g.sizeInMb >= 500 && g.sizeInMb <= 2048).toList();
      case SizeFilter.large:
        return games.where((g) => g.sizeInMb > 2048).toList();
    }
  }

  List<Game> _applyRecencyFilter(List<Game> games, RecencyFilter filter) {
    if (filter == RecencyFilter.all) return games;

    final now = DateTime.now();
    return games.where((g) {
      final updatedDate = DateTime.tryParse(g.lastUpdated);
      if (updatedDate == null) return false;

      final daysDiff = now.difference(updatedDate).inDays;
      return switch (filter) {
        RecencyFilter.all => true,
        RecencyFilter.lastWeek => daysDiff <= 7,
        RecencyFilter.lastMonth => daysDiff <= 30,
        RecencyFilter.lastYear => daysDiff <= 365,
      };
    }).toList();
  }
}

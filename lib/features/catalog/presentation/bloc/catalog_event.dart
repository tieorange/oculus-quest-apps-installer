import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:quest_game_manager/features/catalog/domain/entities/game.dart';

part 'catalog_event.freezed.dart';

/// Events for CatalogBloc.
@freezed
sealed class CatalogEvent with _$CatalogEvent {
  const factory CatalogEvent.load() = CatalogLoad;
  const factory CatalogEvent.refresh() = CatalogRefresh;
  const factory CatalogEvent.search(String query) = CatalogSearch;
  const factory CatalogEvent.filterByStatus(GameStatusFilter filter) = CatalogFilterByStatus;
  const factory CatalogEvent.filterBySize(SizeFilter sizeFilter) = CatalogFilterBySize;
  const factory CatalogEvent.filterByRecency(RecencyFilter recencyFilter) = CatalogFilterByRecency;
  const factory CatalogEvent.sortBy(SortType sortType) = CatalogSortBy;
  const factory CatalogEvent.updateGames(List<Game> games) = CatalogUpdateGames;
  const factory CatalogEvent.clearFilters() = CatalogClearFilters;
}

/// Filter by install status.
enum GameStatusFilter { all, installed, notInstalled }

/// Sort options for the catalog.
enum SortType {
  name, // A-Z
  nameDescending, // Z-A
  lastUpdated, // Newest updates first
  size, // Largest first
  sizeAscending, // Smallest first
}

/// Filter by game size.
enum SizeFilter {
  all, // No size filter
  small, // < 500 MB
  medium, // 500 MB - 2 GB
  large, // > 2 GB
}

/// Filter by update recency.
enum RecencyFilter {
  all, // No recency filter
  lastWeek, // Updated within 7 days
  lastMonth, // Updated within 30 days
  lastYear, // Updated within 365 days
}

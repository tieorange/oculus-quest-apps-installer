import 'package:freezed_annotation/freezed_annotation.dart';

part 'catalog_event.freezed.dart';

/// Events for CatalogBloc.
@freezed
sealed class CatalogEvent with _$CatalogEvent {
  const factory CatalogEvent.load() = CatalogLoad;
  const factory CatalogEvent.refresh() = CatalogRefresh;
  const factory CatalogEvent.search(String query) = CatalogSearch;
  const factory CatalogEvent.filterByStatus(GameStatusFilter filter) = CatalogFilterByStatus;
  const factory CatalogEvent.sortBy(SortType sortType) = CatalogSortBy;
}

enum GameStatusFilter { all, installed, notInstalled }

enum SortType { name, nameDesc, lastUpdated, size }

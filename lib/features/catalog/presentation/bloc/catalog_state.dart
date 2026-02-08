import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:quest_game_manager/core/error/failures.dart';
import 'package:quest_game_manager/features/catalog/domain/entities/game.dart';
import 'package:quest_game_manager/features/catalog/presentation/bloc/catalog_event.dart';

part 'catalog_state.freezed.dart';

/// States for CatalogBloc.
@freezed
sealed class CatalogState with _$CatalogState {
  const factory CatalogState.initial() = CatalogInitial;
  const factory CatalogState.loading() = CatalogLoading;
  const factory CatalogState.loaded({
    required List<Game> games,
    required List<Game> filteredGames,
    required String searchQuery,
    required SortType sortType,
    required GameStatusFilter statusFilter,
    required Set<String> installedPackages,
    @Default(SizeFilter.all) SizeFilter sizeFilter,
    @Default(RecencyFilter.all) RecencyFilter recencyFilter,
    @Default(0) int freeSpaceMb,

    /// True when background refresh is in progress (stale-while-revalidate).
    @Default(false) bool isRefreshing,
  }) = CatalogLoaded;
  const factory CatalogState.error(Failure failure) = CatalogError;
}

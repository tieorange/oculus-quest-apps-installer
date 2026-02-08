import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quest_game_manager/features/catalog/presentation/bloc/catalog_bloc.dart';
import 'package:quest_game_manager/features/catalog/presentation/bloc/catalog_event.dart';
import 'package:quest_game_manager/features/catalog/presentation/bloc/catalog_state.dart';
import 'package:quest_game_manager/features/catalog/presentation/widgets/game_grid.dart';
import 'package:quest_game_manager/features/catalog/presentation/widgets/search_bar_widget.dart';
import 'package:quest_game_manager/features/catalog/presentation/widgets/sort_filter_bar.dart';
import 'package:quest_game_manager/features/catalog/presentation/widgets/storage_indicator.dart';

/// Main catalog page displaying game grid.
class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Games'),
        actions: const [StorageIndicator(), SizedBox(width: 16)],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.fromLTRB(16, 8, 16, 8), child: SearchBarWidget()),
            const SortFilterBar(),
            // Refreshing indicator when background refresh is in progress
            BlocSelector<CatalogBloc, CatalogState, bool>(
              selector: (state) => state is CatalogLoaded && state.isRefreshing,
              builder: (context, isRefreshing) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: isRefreshing ? 4 : 0,
                  child: isRefreshing ? const LinearProgressIndicator() : const SizedBox.shrink(),
                );
              },
            ),
            Expanded(
              child: BlocBuilder<CatalogBloc, CatalogState>(
                builder: (context, state) {
                  return switch (state) {
                    CatalogInitial() ||
                    CatalogLoading() =>
                      const Center(child: CircularProgressIndicator()),
                    CatalogLoaded(:final filteredGames) => RefreshIndicator(
                        onRefresh: () async {
                          context.read<CatalogBloc>().add(const CatalogEvent.refresh());
                        },
                        child: filteredGames.isEmpty
                            ? const Center(child: Text('No games found'))
                            : GameGrid(games: filteredGames),
                      ),
                    CatalogError(:final failure) => Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.error_outline, size: 64),
                            const SizedBox(height: 16),
                            Text(failure.userMessage, textAlign: TextAlign.center),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: () =>
                                  context.read<CatalogBloc>().add(const CatalogEvent.load()),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                  };
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

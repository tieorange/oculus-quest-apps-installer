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
            Expanded(
              child: BlocBuilder<CatalogBloc, CatalogState>(
                builder: (context, state) {
                  return switch (state) {
                    CatalogInitial() ||
                    CatalogLoading() =>
                      const Center(child: CircularProgressIndicator()),
                    CatalogLoaded(:final filteredGames, :final searchQuery) => RefreshIndicator(
                      onRefresh: () async {
                        context.read<CatalogBloc>().add(const CatalogEvent.refresh());
                      },
                      child: filteredGames.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.search_off, size: 64, color: Colors.grey),
                                  const SizedBox(height: 16),
                                  Text(
                                    searchQuery.isNotEmpty
                                        ? 'No games match "$searchQuery"'
                                        : 'No games found',
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                                  ),
                                ],
                              ),
                            )
                          : Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Showing ${filteredGames.length} games',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
                                    ),
                                  ),
                                ),
                                Expanded(child: GameGrid(games: filteredGames)),
                              ],
                            ),
                    ),
                    CatalogError(:final failure) => Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.error_outline, size: 64, color: Colors.red),
                            const SizedBox(height: 16),
                            Text(failure.userMessage, textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyLarge),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              onPressed: () =>
                                  context.read<CatalogBloc>().add(const CatalogEvent.load()),
                              icon: const Icon(Icons.refresh),
                              label: const Text('Retry'),
                            ),
                          ],
                        ),
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

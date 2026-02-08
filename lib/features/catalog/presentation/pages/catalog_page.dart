import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quest_game_manager/features/catalog/domain/entities/game.dart';
import 'package:quest_game_manager/features/catalog/presentation/bloc/catalog_bloc.dart';
import 'package:quest_game_manager/features/catalog/presentation/bloc/catalog_event.dart';
import 'package:quest_game_manager/features/catalog/presentation/bloc/catalog_state.dart';
import 'package:quest_game_manager/features/catalog/presentation/widgets/game_grid.dart';
import 'package:quest_game_manager/features/catalog/presentation/widgets/search_bar_widget.dart';
import 'package:quest_game_manager/features/catalog/presentation/widgets/sort_filter_bar.dart';
import 'package:quest_game_manager/features/catalog/presentation/widgets/storage_indicator.dart';
import 'package:quest_game_manager/features/downloads/presentation/bloc/downloads_bloc.dart';
import 'package:quest_game_manager/features/downloads/presentation/bloc/downloads_event.dart';

/// Main catalog page displaying game grid with batch select support.
class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  bool _selectionMode = false;
  final Set<String> _selectedPackages = {};

  void _toggleSelection(Game game) {
    setState(() {
      if (_selectedPackages.contains(game.packageName)) {
        _selectedPackages.remove(game.packageName);
        if (_selectedPackages.isEmpty) _selectionMode = false;
      } else {
        _selectedPackages.add(game.packageName);
      }
    });
  }

  void _exitSelectionMode() {
    setState(() {
      _selectionMode = false;
      _selectedPackages.clear();
    });
  }

  void _downloadSelected(List<Game> allGames) {
    final bloc = context.read<DownloadsBloc>();
    for (final game in allGames) {
      if (_selectedPackages.contains(game.packageName)) {
        bloc.add(DownloadsEvent.download(game));
      }
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Added ${_selectedPackages.length} games to download queue')),
    );
    _exitSelectionMode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _selectionMode ? Text('${_selectedPackages.length} selected') : const Text('Games'),
        leading: _selectionMode
            ? IconButton(icon: const Icon(Icons.close), onPressed: _exitSelectionMode)
            : null,
        actions: [
          if (!_selectionMode) ...[
            IconButton(
              icon: const Icon(Icons.checklist),
              tooltip: 'Batch select',
              onPressed: () => setState(() => _selectionMode = true),
            ),
            const StorageIndicator(),
            const SizedBox(width: 16),
          ],
          if (_selectionMode)
            BlocBuilder<CatalogBloc, CatalogState>(
              builder: (context, state) {
                final games = state is CatalogLoaded ? state.filteredGames : <Game>[];
                final allSelected = games.isNotEmpty &&
                    games.every((g) => _selectedPackages.contains(g.packageName));
                return IconButton(
                  icon: Icon(allSelected ? Icons.deselect : Icons.select_all),
                  tooltip: allSelected ? 'Deselect all' : 'Select all',
                  onPressed: () {
                    setState(() {
                      if (allSelected) {
                        _selectedPackages.clear();
                      } else {
                        _selectedPackages.addAll(games.map((g) => g.packageName));
                      }
                    });
                  },
                );
              },
            ),
        ],
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
                    CatalogInitial() => const Center(child: CircularProgressIndicator()),
                    CatalogLoading(:final progress, :final message) => Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 200,
                                child: LinearProgressIndicator(
                                  value: progress,
                                  minHeight: 6,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                '${(progress * 100).toInt()}%',
                                style: Theme.of(context).textTheme.headlineSmall,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                message,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: Colors.grey),
                              ),
                              // Show activity indicator during slow download/extract phase
                              if (progress > 0.05 && progress < 0.90) ...[
                                const SizedBox(height: 16),
                                const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Downloading & extracting game data...',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(color: Colors.grey[600], fontSize: 11),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(color: Colors.grey),
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GameGrid(
                                      games: filteredGames,
                                      selectionMode: _selectionMode,
                                      selectedPackages: _selectedPackages,
                                      onSelectionToggle: _toggleSelection,
                                    ),
                                  ),
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
                              Text(
                                failure.userMessage,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
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
      bottomSheet: _selectionMode && _selectedPackages.isNotEmpty
          ? BlocBuilder<CatalogBloc, CatalogState>(
              builder: (context, state) {
                final games = state is CatalogLoaded ? state.filteredGames : <Game>[];
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, -2))
                    ],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () => _downloadSelected(games),
                    icon: const Icon(Icons.download),
                    label: Text('Download ${_selectedPackages.length} Selected'),
                  ),
                );
              },
            )
          : null,
    );
  }
}

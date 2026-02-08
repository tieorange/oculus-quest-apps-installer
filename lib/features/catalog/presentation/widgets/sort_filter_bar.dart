import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quest_game_manager/features/catalog/presentation/bloc/catalog_bloc.dart';
import 'package:quest_game_manager/features/catalog/presentation/bloc/catalog_event.dart';
import 'package:quest_game_manager/features/catalog/presentation/bloc/catalog_state.dart';

/// Sort and filter bar for catalog with extended options.
class SortFilterBar extends StatelessWidget {
  const SortFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CatalogBloc, CatalogState>(
      builder: (context, state) {
        // Extract values using pattern matching on the state
        final sortType = state.mapOrNull(
              loaded: (s) => s.sortType,
            ) ??
            SortType.lastUpdated;

        final statusFilter = state.mapOrNull(
              loaded: (s) => s.statusFilter,
            ) ??
            GameStatusFilter.all;

        final sizeFilter = state.mapOrNull(
              loaded: (s) => s.sizeFilter,
            ) ??
            SizeFilter.all;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // Sort dropdown with extended options
                DropdownButton<SortType>(
                  value: sortType,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(value: SortType.lastUpdated, child: Text('Recent')),
                    DropdownMenuItem(value: SortType.name, child: Text('A-Z')),
                    DropdownMenuItem(value: SortType.nameDescending, child: Text('Z-A')),
                    DropdownMenuItem(value: SortType.size, child: Text('Largest')),
                    DropdownMenuItem(value: SortType.sizeAscending, child: Text('Smallest')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      context.read<CatalogBloc>().add(CatalogEvent.sortBy(value));
                    }
                  },
                ),
                const SizedBox(width: 16),

                // Status filter chips
                ChoiceChip(
                  label: const Text('All'),
                  selected: statusFilter == GameStatusFilter.all,
                  onSelected: (_) => context.read<CatalogBloc>().add(
                        const CatalogEvent.filterByStatus(GameStatusFilter.all),
                      ),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Installed'),
                  selected: statusFilter == GameStatusFilter.installed,
                  onSelected: (_) => context.read<CatalogBloc>().add(
                        const CatalogEvent.filterByStatus(GameStatusFilter.installed),
                      ),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Not Installed'),
                  selected: statusFilter == GameStatusFilter.notInstalled,
                  onSelected: (_) => context.read<CatalogBloc>().add(
                        const CatalogEvent.filterByStatus(GameStatusFilter.notInstalled),
                      ),
                ),
                const SizedBox(width: 16),

                // Size filter dropdown
                DropdownButton<SizeFilter>(
                  value: sizeFilter,
                  underline: const SizedBox(),
                  hint: const Text('Size'),
                  items: const [
                    DropdownMenuItem(value: SizeFilter.all, child: Text('All Sizes')),
                    DropdownMenuItem(value: SizeFilter.small, child: Text('< 500 MB')),
                    DropdownMenuItem(value: SizeFilter.medium, child: Text('500MB - 2GB')),
                    DropdownMenuItem(value: SizeFilter.large, child: Text('> 2 GB')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      context.read<CatalogBloc>().add(CatalogEvent.filterBySize(value));
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

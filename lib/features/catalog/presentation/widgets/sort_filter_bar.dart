import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quest_game_manager/features/catalog/presentation/bloc/catalog_bloc.dart';
import 'package:quest_game_manager/features/catalog/presentation/bloc/catalog_event.dart';
import 'package:quest_game_manager/features/catalog/presentation/bloc/catalog_state.dart';

/// Sort and filter bar for catalog.
class SortFilterBar extends StatelessWidget {
  const SortFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CatalogBloc, CatalogState>(
      builder: (context, state) {
        final sortType = switch (state) {
          CatalogLoaded(:final sortType) => sortType,
          _ => SortType.lastUpdated,
        };
        final filter = switch (state) {
          CatalogLoaded(:final filter) => filter,
          _ => GameStatusFilter.all,
        };

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                DropdownButton<SortType>(
                  value: sortType,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(value: SortType.lastUpdated, child: Text('Recent')),
                    DropdownMenuItem(value: SortType.name, child: Text('Name (A-Z)')),
                    DropdownMenuItem(value: SortType.nameDesc, child: Text('Name (Z-A)')),
                    DropdownMenuItem(value: SortType.size, child: Text('Size')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      context.read<CatalogBloc>().add(CatalogEvent.sortBy(value));
                    }
                  },
                ),
                const SizedBox(width: 16),
                ChoiceChip(
                  label: const Text('All'),
                  selected: filter == GameStatusFilter.all,
                  onSelected: (_) => context.read<CatalogBloc>().add(
                        const CatalogEvent.filterByStatus(GameStatusFilter.all),
                      ),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Installed'),
                  selected: filter == GameStatusFilter.installed,
                  onSelected: (_) => context.read<CatalogBloc>().add(
                        const CatalogEvent.filterByStatus(GameStatusFilter.installed),
                      ),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Not Installed'),
                  selected: filter == GameStatusFilter.notInstalled,
                  onSelected: (_) => context.read<CatalogBloc>().add(
                        const CatalogEvent.filterByStatus(GameStatusFilter.notInstalled),
                      ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

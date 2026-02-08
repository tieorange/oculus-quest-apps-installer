import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quest_game_manager/features/catalog/presentation/bloc/catalog_bloc.dart';
import 'package:quest_game_manager/features/catalog/presentation/bloc/catalog_state.dart';

/// Widget displaying available storage space from CatalogBloc state.
class StorageIndicator extends StatelessWidget {
  const StorageIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CatalogBloc, CatalogState>(
      builder: (context, state) {
        final freeSpaceMb = state.maybeMap(
          loaded: (s) => s.freeSpaceMb,
          orElse: () => 0,
        );

        if (freeSpaceMb <= 0) {
          return const SizedBox.shrink();
        }

        final freeGb = freeSpaceMb / 1024;
        final color = freeGb < 2
            ? Colors.red
            : freeGb < 10
                ? Colors.orange
                : Theme.of(context).colorScheme.primary;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.storage, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                '${freeGb.toStringAsFixed(1)} GB free',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(color: color),
              ),
            ],
          ),
        );
      },
    );
  }
}

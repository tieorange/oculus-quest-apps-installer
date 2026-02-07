import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quest_game_manager/core/theme/app_theme.dart';
import 'package:quest_game_manager/features/catalog/domain/entities/game.dart';
import 'package:quest_game_manager/features/downloads/presentation/bloc/downloads_bloc.dart';
import 'package:quest_game_manager/features/downloads/presentation/bloc/downloads_event.dart';

/// Bottom sheet showing game details with install button.
class GameDetailSheet extends StatelessWidget {
  const GameDetailSheet({required this.game, required this.isInstalled, super.key});

  final Game game;
  final bool isInstalled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xFF16213E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 24),
          Text(game.name, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            game.packageName,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          _buildInfoRow(context),
          const SizedBox(height: 32),
          _buildActionButton(context),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildInfoItem(context, Icons.storage, '${game.sizeMb} MB', 'Size'),
        _buildInfoItem(context, Icons.update, game.lastUpdated, 'Updated'),
        _buildInfoItem(context, Icons.tag, 'v${game.versionCode}', 'Version'),
      ],
    );
  }

  Widget _buildInfoItem(BuildContext context, IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 8),
        Text(value, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context) {
    if (isInstalled) {
      return ElevatedButton.icon(
        onPressed: null,
        icon: const Icon(Icons.check_circle_outline),
        label: const Text('Installed'),
        style: ElevatedButton.styleFrom(backgroundColor: AppTheme.success),
      );
    }

    return ElevatedButton.icon(
      onPressed: () {
        context.read<DownloadsBloc>().add(DownloadsEvent.download(game));
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Added ${game.name} to download queue')));
      },
      icon: const Icon(Icons.download),
      label: const Text('Download & Install'),
    );
  }
}

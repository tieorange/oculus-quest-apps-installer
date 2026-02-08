// ignore_for_file: avoid_slow_async_io

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quest_game_manager/core/constants/app_constants.dart';
import 'package:quest_game_manager/core/theme/app_theme.dart';
import 'package:quest_game_manager/core/utils/file_utils.dart';
import 'package:quest_game_manager/features/catalog/domain/entities/game.dart';
import 'package:quest_game_manager/features/downloads/domain/entities/download_task.dart';
import 'package:quest_game_manager/features/downloads/presentation/bloc/downloads_bloc.dart';
import 'package:quest_game_manager/features/downloads/presentation/bloc/downloads_event.dart';
import 'package:quest_game_manager/features/downloads/presentation/bloc/downloads_state.dart';
import 'package:quest_game_manager/features/favorites/presentation/cubit/favorites_cubit.dart';

/// Full-page game detail view.
class GameDetailPage extends StatelessWidget {
  const GameDetailPage({
    required this.game,
    this.isInstalled = false,
    this.installedVersion,
    super.key,
  });

  final Game game;
  final bool isInstalled;
  final int? installedVersion;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(game.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          BlocBuilder<FavoritesCubit, FavoritesState>(
            builder: (context, favState) {
              final isFav = favState.favorites.contains(game.packageName);
              return IconButton(
                icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
                color: isFav ? Colors.redAccent : null,
                onPressed: () {
                  context.read<FavoritesCubit>().toggleFavorite(game.packageName);
                },
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hero thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  height: 200,
                  child: _HeroThumbnail(packageName: game.packageName),
                ),
              ),
              const SizedBox(height: 24),

              // Game title
              Text(game.name, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text(
                game.packageName,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
              ),
              const SizedBox(height: 24),

              // Info cards row
              Row(
                children: [
                  _InfoCard(icon: Icons.storage, label: 'Size', value: '${game.sizeMb} MB'),
                  const SizedBox(width: 12),
                  _InfoCard(icon: Icons.calendar_today, label: 'Updated', value: game.lastUpdated),
                  const SizedBox(width: 12),
                  _InfoCard(icon: Icons.tag, label: 'Version', value: 'v${game.versionCode}'),
                ],
              ),
              const SizedBox(height: 16),

              // Update available indicator
              if (isInstalled &&
                  installedVersion != null &&
                  (int.tryParse(game.versionCode) ?? 0) > installedVersion!) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.warning.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.warning.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.system_update, color: AppTheme.warning),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Update available! Installed: v$installedVersion, Latest: v${game.versionCode}',
                          style: const TextStyle(color: AppTheme.warning),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Game notes
              _GameNotes(packageName: game.packageName),

              const SizedBox(height: 24),

              // Action button
              _ActionButton(game: game, isInstalled: isInstalled),

              const SizedBox(height: 16),

              // Download progress if active
              BlocBuilder<DownloadsBloc, DownloadsState>(
                builder: (context, state) {
                  if (state is! DownloadsLoaded) return const SizedBox.shrink();
                  final activeTask = state.queue.where(
                    (t) => t.game.packageName == game.packageName &&
                        t.status != DownloadStatus.completed &&
                        t.status != DownloadStatus.failed,
                  );
                  if (activeTask.isEmpty) return const SizedBox.shrink();
                  final task = activeTask.first;
                  return _DownloadProgress(task: task);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroThumbnail extends StatelessWidget {
  const _HeroThumbnail({required this.packageName});
  final String packageName;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getThumbnailPath(),
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          return Image.file(
            File(snapshot.data!),
            fit: BoxFit.cover,
            width: double.infinity,
            errorBuilder: (_, __, ___) => _placeholder(),
          );
        }
        return _placeholder();
      },
    );
  }

  Widget _placeholder() {
    return Container(
      color: const Color(0xFF2A2A40),
      child: const Center(
        child: Icon(Icons.sports_esports, size: 80, color: Colors.white24),
      ),
    );
  }

  Future<String?> _getThumbnailPath() async {
    final dataDir = await getApplicationDocumentsDirectory();
    final path = '${dataDir.path}/${AppConstants.thumbnailsPath}/$packageName.jpg';
    if (await File(path).exists()) return path;
    return null;
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary, size: 24),
            const SizedBox(height: 8),
            Text(value, style: Theme.of(context).textTheme.titleSmall, textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

class _GameNotes extends StatelessWidget {
  const _GameNotes({required this.packageName});
  final String packageName;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _loadNotes(),
      builder: (context, snapshot) {
        if (snapshot.data == null || snapshot.data!.isEmpty) return const SizedBox.shrink();
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Notes', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              Text(snapshot.data!, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        );
      },
    );
  }

  Future<String?> _loadNotes() async {
    try {
      final dataDir = await getApplicationDocumentsDirectory();
      final path = '${dataDir.path}/${AppConstants.notesPath}/$packageName.txt';
      final file = File(path);
      if (await file.exists()) {
        return file.readAsString();
      }
    } catch (_) {}
    return null;
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.game, required this.isInstalled});
  final Game game;
  final bool isInstalled;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DownloadsBloc, DownloadsState>(
      builder: (context, state) {
        // Check if already in queue
        final inQueue = state is DownloadsLoaded &&
            state.queue.any((t) =>
                t.game.packageName == game.packageName &&
                t.status != DownloadStatus.completed &&
                t.status != DownloadStatus.failed);

        if (inQueue) {
          return ElevatedButton.icon(
            onPressed: null,
            icon: const SizedBox(
              width: 20, height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            label: const Text('In Progress...'),
          );
        }

        if (isInstalled) {
          return Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: null,
                  icon: const Icon(Icons.check_circle),
                  label: const Text('Installed'),
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.success),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: () {
                  context.read<DownloadsBloc>().add(DownloadsEvent.download(game));
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.update),
                label: const Text('Update'),
              ),
            ],
          );
        }

        return SizedBox(
          height: 56,
          child: ElevatedButton.icon(
            onPressed: () {
              context.read<DownloadsBloc>().add(DownloadsEvent.download(game));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${game.name} added to download queue')),
              );
            },
            icon: const Icon(Icons.download),
            label: const Text('Download & Install'),
          ),
        );
      },
    );
  }
}

class _DownloadProgress extends StatelessWidget {
  const _DownloadProgress({required this.task});
  final DownloadTask task;

  @override
  Widget build(BuildContext context) {
    final stageLabel = switch (task.pipelineStage) {
      PipelineStage.downloading => 'Downloading${task.totalParts > 0 ? ' (Part ${task.currentPart}/${task.totalParts})' : ''}',
      PipelineStage.extracting => 'Extracting...',
      PipelineStage.installing => 'Installing...',
      PipelineStage.copyingObb => 'Copying game data...',
      PipelineStage.cleaning => 'Cleaning up...',
      PipelineStage.done => 'Complete!',
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(stageLabel, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 12),
            LinearProgressIndicator(value: task.progress),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${(task.progress * 100).toStringAsFixed(0)}%',
                    style: Theme.of(context).textTheme.bodySmall),
                if (task.pipelineStage == PipelineStage.downloading)
                  Text(FileUtils.formatSpeed(task.speedBytesPerSecond),
                      style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

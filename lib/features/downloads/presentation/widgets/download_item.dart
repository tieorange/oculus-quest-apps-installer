import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quest_game_manager/core/theme/app_theme.dart';
import 'package:quest_game_manager/core/utils/file_utils.dart';
import 'package:quest_game_manager/features/downloads/domain/entities/download_task.dart';
import 'package:quest_game_manager/features/downloads/presentation/bloc/downloads_bloc.dart';
import 'package:quest_game_manager/features/downloads/presentation/bloc/downloads_event.dart';

/// Widget displaying a single download task.
class DownloadItem extends StatelessWidget {
  const DownloadItem({required this.task, super.key});

  final DownloadTask task;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.game.name,
                        style: Theme.of(context).textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      _buildStatusText(context),
                    ],
                  ),
                ),
                _buildActions(context),
              ],
            ),
            if (task.status == DownloadStatus.downloading ||
                task.status == DownloadStatus.extracting) ...[
              const SizedBox(height: 12),
              LinearProgressIndicator(value: task.progress, backgroundColor: Colors.white12),
              const SizedBox(height: 8),
              _buildProgressInfo(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusText(BuildContext context) {
    final (text, color) = switch (task.status) {
      DownloadStatus.queued => ('Queued', Colors.grey),
      DownloadStatus.downloading => ('Downloading...', AppTheme.success),
      DownloadStatus.paused => ('Paused', Colors.orange),
      DownloadStatus.extracting => ('Extracting...', AppTheme.success),
      DownloadStatus.completed => ('Completed', AppTheme.success),
      DownloadStatus.failed => ('Failed', AppTheme.error),
    };

    return Text(text, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: color));
  }

  Widget _buildProgressInfo(BuildContext context) {
    final progressPercent = (task.progress * 100).toStringAsFixed(1);
    final speedText = FileUtils.formatSpeed(task.speedBytesPerSecond);
    final etaText = FileUtils.formatEta(
      task.totalBytes - task.bytesReceived,
      task.speedBytesPerSecond,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('$progressPercent%', style: Theme.of(context).textTheme.bodySmall),
        Text(speedText, style: Theme.of(context).textTheme.bodySmall),
        Text('ETA: $etaText', style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    return switch (task.status) {
      DownloadStatus.queued || DownloadStatus.downloading || DownloadStatus.paused => IconButton(
        icon: const Icon(Icons.cancel_outlined),
        onPressed: () => context.read<DownloadsBloc>().add(DownloadsEvent.cancel(task.gameId)),
      ),
      DownloadStatus.failed => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<DownloadsBloc>().add(DownloadsEvent.retry(task.gameId)),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => context.read<DownloadsBloc>().add(DownloadsEvent.remove(task.gameId)),
          ),
        ],
      ),
      DownloadStatus.extracting => const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
      DownloadStatus.completed => IconButton(
        icon: const Icon(Icons.check_circle, color: AppTheme.success),
        onPressed: () => context.read<DownloadsBloc>().add(DownloadsEvent.remove(task.gameId)),
      ),
    };
  }
}

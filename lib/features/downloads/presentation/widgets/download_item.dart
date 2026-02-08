import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quest_game_manager/core/theme/app_theme.dart';
import 'package:quest_game_manager/core/utils/file_utils.dart';
import 'package:quest_game_manager/features/downloads/domain/entities/download_task.dart';
import 'package:quest_game_manager/features/downloads/presentation/bloc/downloads_bloc.dart';
import 'package:quest_game_manager/features/downloads/presentation/bloc/downloads_event.dart';

/// Widget displaying a single download task with pipeline stage.
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
                _stageIcon(),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(task.game.name,
                          style: Theme.of(context).textTheme.titleMedium,
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      _StatusLabel(task: task),
                    ],
                  ),
                ),
                _buildActions(context),
              ],
            ),
            if (_showProgress) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: task.progress,
                  backgroundColor: Colors.white12,
                  minHeight: 6,
                ),
              ),
              const SizedBox(height: 8),
              _ProgressDetails(task: task),
            ],
          ],
        ),
      ),
    );
  }

  bool get _showProgress =>
      task.status == DownloadStatus.downloading ||
      task.status == DownloadStatus.extracting ||
      task.status == DownloadStatus.installing;

  Widget _stageIcon() {
    final (icon, color) = switch (task.status) {
      DownloadStatus.queued => (Icons.schedule, Colors.grey),
      DownloadStatus.downloading => (Icons.downloading, const Color(0xFF00D9FF)),
      DownloadStatus.paused => (Icons.pause_circle, Colors.orange),
      DownloadStatus.extracting => (Icons.unarchive, Colors.amber),
      DownloadStatus.installing => (Icons.install_mobile, Colors.purple),
      DownloadStatus.completed => (Icons.check_circle, AppTheme.success),
      DownloadStatus.failed => (Icons.error, AppTheme.error),
    };
    return Icon(icon, color: color, size: 28);
  }

  Widget _buildActions(BuildContext context) {
    return switch (task.status) {
      DownloadStatus.queued ||
      DownloadStatus.downloading ||
      DownloadStatus.paused => IconButton(
        icon: const Icon(Icons.close),
        tooltip: 'Cancel',
        onPressed: () => context.read<DownloadsBloc>().add(DownloadsEvent.cancel(task.gameId)),
      ),
      DownloadStatus.failed => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Retry',
            onPressed: () => context.read<DownloadsBloc>().add(DownloadsEvent.retry(task.gameId)),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Remove',
            onPressed: () => context.read<DownloadsBloc>().add(DownloadsEvent.remove(task.gameId)),
          ),
        ],
      ),
      DownloadStatus.extracting ||
      DownloadStatus.installing => const SizedBox(
        width: 24, height: 24,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
      DownloadStatus.completed => IconButton(
        icon: const Icon(Icons.check_circle, color: AppTheme.success),
        tooltip: 'Done',
        onPressed: () => context.read<DownloadsBloc>().add(DownloadsEvent.remove(task.gameId)),
      ),
    };
  }
}

class _StatusLabel extends StatelessWidget {
  const _StatusLabel({required this.task});
  final DownloadTask task;

  @override
  Widget build(BuildContext context) {
    final label = switch (task.pipelineStage) {
      PipelineStage.downloading => task.totalParts > 0
          ? 'Downloading part ${task.currentPart}/${task.totalParts}'
          : 'Downloading...',
      PipelineStage.extracting => 'Extracting archive...',
      PipelineStage.installing => 'Installing APK...',
      PipelineStage.copyingObb => 'Copying game data...',
      PipelineStage.cleaning => 'Cleaning up...',
      PipelineStage.done => 'Complete!',
    };

    final statusLabel = switch (task.status) {
      DownloadStatus.queued => 'Waiting in queue',
      DownloadStatus.paused => 'Paused',
      DownloadStatus.failed => 'Failed',
      DownloadStatus.completed => 'Installed successfully',
      _ => label,
    };

    final color = switch (task.status) {
      DownloadStatus.queued => Colors.grey,
      DownloadStatus.downloading => const Color(0xFF00D9FF),
      DownloadStatus.paused => Colors.orange,
      DownloadStatus.extracting => Colors.amber,
      DownloadStatus.installing => Colors.purple,
      DownloadStatus.completed => AppTheme.success,
      DownloadStatus.failed => AppTheme.error,
    };

    return Text(statusLabel, style: TextStyle(fontSize: 13, color: color));
  }
}

class _ProgressDetails extends StatelessWidget {
  const _ProgressDetails({required this.task});
  final DownloadTask task;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('${(task.progress * 100).toStringAsFixed(0)}%', style: style),
        if (task.pipelineStage == PipelineStage.downloading && task.speedBytesPerSecond > 0)
          Text(FileUtils.formatSpeed(task.speedBytesPerSecond), style: style),
        if (task.bytesReceived > 0)
          Text(FileUtils.formatBytes(task.bytesReceived), style: style),
      ],
    );
  }
}

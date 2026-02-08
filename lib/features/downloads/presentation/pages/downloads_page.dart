import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quest_game_manager/features/downloads/domain/entities/download_task.dart';
import 'package:quest_game_manager/features/downloads/presentation/bloc/downloads_bloc.dart';
import 'package:quest_game_manager/features/downloads/presentation/bloc/downloads_event.dart';
import 'package:quest_game_manager/features/downloads/presentation/bloc/downloads_state.dart';
import 'package:quest_game_manager/features/downloads/presentation/widgets/download_item.dart';
import 'package:quest_game_manager/features/downloads/presentation/widgets/empty_downloads.dart';

/// Page displaying download queue with pipeline progress.
class DownloadsPage extends StatelessWidget {
  const DownloadsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Downloads'),
        actions: [
          BlocBuilder<DownloadsBloc, DownloadsState>(
            builder: (context, state) {
              if (state is! DownloadsLoaded || state.queue.isEmpty) {
                return const SizedBox.shrink();
              }
              final hasActive = state.queue.any((t) =>
                  t.status == DownloadStatus.downloading ||
                  t.status == DownloadStatus.extracting ||
                  t.status == DownloadStatus.installing,);
              final hasPaused = state.queue.any((t) => t.status == DownloadStatus.paused);

              return Row(
                children: [
                  if (hasActive)
                    IconButton(
                      icon: const Icon(Icons.pause_circle_outline),
                      tooltip: 'Pause All',
                      onPressed: () =>
                          context.read<DownloadsBloc>().add(const DownloadsEvent.pauseAll()),
                    ),
                  if (hasPaused)
                    IconButton(
                      icon: const Icon(Icons.play_circle_outline),
                      tooltip: 'Resume All',
                      onPressed: () =>
                          context.read<DownloadsBloc>().add(const DownloadsEvent.resumeAll()),
                    ),
                ],
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<DownloadsBloc, DownloadsState>(
          builder: (context, state) {
            return switch (state) {
              DownloadsInitial() ||
              DownloadsLoading() =>
                const Center(child: CircularProgressIndicator()),
              DownloadsLoaded(:final queue) => queue.isEmpty
                  ? const EmptyDownloads()
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: queue.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: DownloadItem(task: queue[index]),
                        );
                      },
                    ),
              DownloadsError(:final failure) => Center(
                child: Text(failure.userMessage),
              ),
            };
          },
        ),
      ),
    );
  }
}

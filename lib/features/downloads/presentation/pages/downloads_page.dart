import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quest_game_manager/features/downloads/presentation/bloc/downloads_bloc.dart';
import 'package:quest_game_manager/features/downloads/presentation/bloc/downloads_state.dart';
import 'package:quest_game_manager/features/downloads/presentation/widgets/download_item.dart';
import 'package:quest_game_manager/features/downloads/presentation/widgets/empty_downloads.dart';

/// Page displaying download queue.
class DownloadsPage extends StatelessWidget {
  const DownloadsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Downloads')),
      body: SafeArea(
        child: BlocBuilder<DownloadsBloc, DownloadsState>(
          builder: (context, state) {
            return switch (state) {
              DownloadsInitial() ||
              DownloadsLoading() => const Center(child: CircularProgressIndicator()),
              DownloadsLoaded(:final queue) =>
                queue.isEmpty
                    ? const EmptyDownloads()
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: queue.length,
                        itemBuilder: (context, index) {
                          return DownloadItem(task: queue[index]);
                        },
                      ),
              DownloadsError(:final failure) => Center(child: Text(failure.userMessage)),
            };
          },
        ),
      ),
    );
  }
}

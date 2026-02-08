import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quest_game_manager/features/settings/presentation/cubit/settings_cubit.dart';

class ClearDownloadsDialog extends StatelessWidget {
  const ClearDownloadsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsCubit, SettingsState>(
      listenWhen: (previous, current) => previous.clearingStatus != current.clearingStatus,
      listener: (context, state) {
        if (state.clearingStatus == ClearingStatus.success) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Downloads cleared successfully')),
          );
        } else if (state.clearingStatus == ClearingStatus.failure) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.clearingError ?? 'Failed to clear downloads'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return AlertDialog(
          title: const Text('Clear Downloads?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'This will remove all downloaded game files and installers. '
                'It will NOT uninstall games from your device.',
              ),
              if (state.downloadsSize > 0) ...[
                const SizedBox(height: 16),
                Text(
                  'Approximate space to free: ${_formatSize(state.downloadsSize)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            if (state.clearingStatus == ClearingStatus.loading)
              const CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: () {
                  context.read<SettingsCubit>().clearDownloads();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Theme.of(context).colorScheme.onError,
                ),
                child: const Text('Clear All'),
              ),
          ],
        );
      },
    );
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }
}

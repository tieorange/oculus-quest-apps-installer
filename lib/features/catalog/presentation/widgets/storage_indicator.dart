import 'package:flutter/material.dart';
import 'package:quest_game_manager/core/utils/file_utils.dart';

/// Widget displaying available storage space with live data.
class StorageIndicator extends StatefulWidget {
  const StorageIndicator({super.key});

  @override
  State<StorageIndicator> createState() => _StorageIndicatorState();
}

class _StorageIndicatorState extends State<StorageIndicator> {
  int _freeSpaceMb = -1;

  @override
  void initState() {
    super.initState();
    _loadSpace();
  }

  Future<void> _loadSpace() async {
    final free = await FileUtils.getFreeSpaceMb('/data');
    if (mounted) {
      setState(() => _freeSpaceMb = free);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_freeSpaceMb < 0) {
      return const SizedBox.shrink();
    }

    final freeGb = _freeSpaceMb / 1024;
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
  }
}

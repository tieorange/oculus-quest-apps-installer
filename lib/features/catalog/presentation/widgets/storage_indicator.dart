import 'package:flutter/material.dart';

/// Widget displaying available storage space.
class StorageIndicator extends StatelessWidget {
  const StorageIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO(user): Implement actual storage checking
    const freeGb = 24.5;
    const totalGb = 128.0;
    const usedPercent = (totalGb - freeGb) / totalGb;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 80,
            child: LinearProgressIndicator(
              value: usedPercent,
              backgroundColor: Colors.white24,
              valueColor: AlwaysStoppedAnimation<Color>(
                usedPercent > 0.9 ? Colors.red : Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${freeGb.toStringAsFixed(1)} GB free',
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}

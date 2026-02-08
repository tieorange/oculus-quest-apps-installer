import 'package:flutter/material.dart';

/// An animated progress bar that smoothly transitions between values.
class AnimatedProgressBar extends StatelessWidget {
  const AnimatedProgressBar({
    required this.progress,
    this.height = 6,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius = 3,
    this.duration = const Duration(milliseconds: 300),
    super.key,
  });

  final double progress;
  final double height;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double borderRadius;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = backgroundColor ?? theme.colorScheme.surface;
    final fgColor = foregroundColor ?? theme.colorScheme.primary;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              AnimatedContainer(
                duration: duration,
                curve: Curves.easeInOut,
                width: constraints.maxWidth * progress.clamp(0.0, 1.0),
                decoration: BoxDecoration(
                  color: fgColor,
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

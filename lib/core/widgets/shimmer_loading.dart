import 'package:flutter/material.dart';

/// Shimmer loading placeholder for content that hasn't loaded yet.
class ShimmerLoading extends StatefulWidget {
  const ShimmerLoading({
    required this.width,
    required this.height,
    this.borderRadius = 8,
    super.key,
  });

  final double width;
  final double height;
  final double borderRadius;

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment(-1.0 + 2.0 * _controller.value, 0),
              end: Alignment(-1.0 + 2.0 * _controller.value + 1.0, 0),
              colors: const [
                Color(0xFF1A1A2E),
                Color(0xFF2A2A45),
                Color(0xFF1A1A2E),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// A shimmer placeholder shaped like a game card.
class GameCardShimmer extends StatelessWidget {
  const GameCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: 100,
        child: Row(
          children: [
            ShimmerLoading(width: 100, height: 100, borderRadius: 0),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ShimmerLoading(width: 180, height: 16),
                  SizedBox(height: 12),
                  ShimmerLoading(width: 120, height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

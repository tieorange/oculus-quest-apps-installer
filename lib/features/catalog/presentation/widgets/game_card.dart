// ignore_for_file: avoid_slow_async_io
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:quest_game_manager/core/theme/app_theme.dart';
import 'package:quest_game_manager/features/catalog/domain/entities/game.dart';
import 'package:quest_game_manager/features/catalog/presentation/widgets/game_detail_sheet.dart';

/// Card widget displaying a single game.
class GameCard extends StatelessWidget {
  const GameCard({required this.game, this.isInstalled = false, super.key});

  final Game game;
  final bool isInstalled;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _showGameDetails(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(flex: 3, child: _buildThumbnail()),
            Expanded(flex: 2, child: _buildInfo(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
    return Stack(
      fit: StackFit.expand,
      children: [
        FutureBuilder<bool>(
          future: _thumbnailExists(),
          builder: (context, snapshot) {
            final exists = snapshot.data ?? false;
            if (exists) {
              return Image.file(
                File(_getThumbnailPath()),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _placeholderThumbnail(),
              );
            }
            return _placeholderThumbnail();
          },
        ),
        if (isInstalled)
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.success,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'INSTALLED',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
      ],
    );
  }

  Widget _placeholderThumbnail() {
    return const ColoredBox(
      color: Color(0xFF2A2A40),
      child: Center(child: Icon(Icons.sports_esports, size: 48, color: Colors.white38)),
    );
  }

  Widget _buildInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            game.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const Spacer(),
          Row(
            children: [
              const Icon(Icons.storage, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                '${game.sizeMb} MB',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<bool> _thumbnailExists() async {
    final file = File(_getThumbnailPath());
    return file.exists();
  }

  String _getThumbnailPath() {
    // This would be properly resolved by the catalog repository
    return '/data/data/com.questgamemanager.quest_game_manager/files/'
        '.meta/thumbnails/${game.packageName}.jpg';
  }

  void _showGameDetails(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => GameDetailSheet(game: game, isInstalled: isInstalled),
    );
  }
}

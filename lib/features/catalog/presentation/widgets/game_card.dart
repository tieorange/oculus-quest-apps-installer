// ignore_for_file: avoid_slow_async_io
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quest_game_manager/core/constants/app_constants.dart';
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
        child: SizedBox(
          height: 100,
          child: Row(
            children: [
              SizedBox(
                width: 100,
                child: _buildThumbnail(),
              ),
              Expanded(child: _buildInfo(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
    return Stack(
      fit: StackFit.expand,
      children: [
        FutureBuilder<String?>(
          future: _getValidThumbnailPath(),
          builder: (context, snapshot) {
            final path = snapshot.data;
            if (path != null) {
              return Image.file(
                File(path),
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
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            game.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.storage, size: 12, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                '${game.sizeMb} MB',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.grey, fontSize: 12),
              ),
              ...[
                const SizedBox(width: 12),
                const Icon(Icons.update, size: 12, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  'v${game.versionCode}',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.grey, fontSize: 12),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  /// Returns the thumbnail path if the file exists, otherwise null.
  Future<String?> _getValidThumbnailPath() async {
    final dataDir = await getApplicationDocumentsDirectory();
    final path = '${dataDir.path}/${AppConstants.thumbnailsPath}/${game.packageName}.jpg';
    final file = File(path);
    if (await file.exists()) {
      return path;
    }
    return null;
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

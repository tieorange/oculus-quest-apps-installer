// ignore_for_file: avoid_slow_async_io
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quest_game_manager/core/constants/app_constants.dart';
import 'package:quest_game_manager/core/theme/app_theme.dart';
import 'package:quest_game_manager/features/catalog/domain/entities/game.dart';
import 'package:quest_game_manager/features/catalog/presentation/pages/game_detail_page.dart';
import 'package:quest_game_manager/features/downloads/presentation/bloc/downloads_bloc.dart';
import 'package:quest_game_manager/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:quest_game_manager/features/installer/presentation/bloc/installer_bloc.dart';

/// Card widget displaying a single game.
class GameCard extends StatelessWidget {
  const GameCard({required this.game, super.key});

  final Game game;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InstallerBloc, InstallerState>(
      builder: (context, installerState) {
        final installed = switch (installerState) {
          InstallerIdle(:final installedPackages) => installedPackages,
          InstallerInstalling(:final installedPackages) => installedPackages,
          InstallerSuccess(:final installedPackages) => installedPackages,
          InstallerFailed(:final installedPackages) => installedPackages,
        };
        final isInstalled = installed.contains(game.packageName);

        return Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider.value(value: context.read<InstallerBloc>()),
                    BlocProvider.value(value: context.read<DownloadsBloc>()),
                    BlocProvider.value(value: context.read<FavoritesCubit>()),
                  ],
                  child: GameDetailPage(game: game, isInstalled: isInstalled),
                ),
              ),
            ),
            child: SizedBox(
              height: 100,
              child: Row(
                children: [
                  SizedBox(width: 100, child: _Thumbnail(game: game, isInstalled: isInstalled)),
                  Expanded(child: _GameInfo(game: game)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Thumbnail extends StatelessWidget {
  const _Thumbnail({required this.game, required this.isInstalled});
  final Game game;
  final bool isInstalled;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        FutureBuilder<String?>(
          future: _getValidThumbnailPath(),
          builder: (context, snapshot) {
            final path = snapshot.data;
            if (path != null) {
              return Image.file(File(path), fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _placeholder());
            }
            return _placeholder();
          },
        ),
        if (isInstalled)
          Positioned(
            top: 4,
            left: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppTheme.success,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text('INSTALLED',
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
      ],
    );
  }

  Widget _placeholder() {
    return const ColoredBox(
      color: Color(0xFF2A2A40),
      child: Center(child: Icon(Icons.sports_esports, size: 40, color: Colors.white24)),
    );
  }

  Future<String?> _getValidThumbnailPath() async {
    final dataDir = await getApplicationDocumentsDirectory();
    final path = '${dataDir.path}/${AppConstants.thumbnailsPath}/${game.packageName}.jpg';
    if (await File(path).exists()) return path;
    return null;
  }
}

class _GameInfo extends StatelessWidget {
  const _GameInfo({required this.game});
  final Game game;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(game.name, maxLines: 2, overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.storage, size: 12, color: Colors.grey),
              const SizedBox(width: 4),
              Text('${game.sizeMb} MB',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
              const SizedBox(width: 12),
              const Icon(Icons.update, size: 12, color: Colors.grey),
              const SizedBox(width: 4),
              Text(game.lastUpdated,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}

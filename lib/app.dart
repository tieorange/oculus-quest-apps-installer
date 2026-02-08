import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quest_game_manager/core/services/connectivity_service.dart';
import 'package:quest_game_manager/core/theme/app_theme.dart';
import 'package:quest_game_manager/features/catalog/presentation/bloc/catalog_bloc.dart';
import 'package:quest_game_manager/features/catalog/presentation/bloc/catalog_event.dart';
import 'package:quest_game_manager/features/catalog/presentation/pages/catalog_page.dart';
import 'package:quest_game_manager/features/downloads/domain/entities/download_task.dart';
import 'package:quest_game_manager/features/downloads/presentation/bloc/downloads_bloc.dart';
import 'package:quest_game_manager/features/downloads/presentation/bloc/downloads_event.dart';
import 'package:quest_game_manager/features/downloads/presentation/bloc/downloads_state.dart';
import 'package:quest_game_manager/features/downloads/presentation/pages/downloads_page.dart';
import 'package:quest_game_manager/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:quest_game_manager/features/installer/presentation/bloc/installer_bloc.dart';
import 'package:quest_game_manager/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:quest_game_manager/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:quest_game_manager/features/settings/presentation/pages/settings_page.dart';
import 'package:quest_game_manager/injection.dart';

/// Root application widget.
class QuestGameManagerApp extends StatelessWidget {
  const QuestGameManagerApp({this.showOnboarding = false, super.key});

  final bool showOnboarding;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<CatalogBloc>()..add(const CatalogEvent.load())),
        BlocProvider(create: (_) => getIt<DownloadsBloc>()..add(const DownloadsEvent.loadQueue())),
        BlocProvider(create: (_) => getIt<InstallerBloc>()..add(const InstallerEvent.refreshInstalled())),
        BlocProvider(create: (_) => getIt<FavoritesCubit>()..loadFavorites()),
        BlocProvider(create: (_) => getIt<SettingsCubit>()),
      ],
      child: MaterialApp(
        title: 'Quest Game Manager',
        theme: AppTheme.dark,
        debugShowCheckedModeBanner: false,
        home: showOnboarding ? const _OnboardingWrapper() : const MainNavigation(),
      ),
    );
  }
}

/// Wrapper that shows onboarding then navigates to main app.
class _OnboardingWrapper extends StatelessWidget {
  const _OnboardingWrapper();

  @override
  Widget build(BuildContext context) {
    return OnboardingPage(
      onComplete: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(builder: (_) => const MainNavigation()),
        );
      },
    );
  }
}

/// Main navigation shell with bottom navigation bar.
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [CatalogPage(), DownloadsPage(), SettingsPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const OfflineBanner(),
          Expanded(
            child: IndexedStack(index: _currentIndex, children: _pages),
          ),
        ],
      ),
      bottomNavigationBar: BlocBuilder<DownloadsBloc, DownloadsState>(
        builder: (context, state) {
          final activeCount = state is DownloadsLoaded
              ? state.queue.where((t) =>
                  t.status == DownloadStatus.downloading ||
                  t.status == DownloadStatus.extracting ||
                  t.status == DownloadStatus.installing ||
                  t.status == DownloadStatus.queued,).length
              : 0;

          return BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.games_outlined),
                activeIcon: Icon(Icons.games),
                label: 'Browse',
              ),
              BottomNavigationBarItem(
                icon: Badge(
                  isLabelVisible: activeCount > 0,
                  label: Text('$activeCount'),
                  child: const Icon(Icons.download_outlined),
                ),
                activeIcon: Badge(
                  isLabelVisible: activeCount > 0,
                  label: Text('$activeCount'),
                  child: const Icon(Icons.download),
                ),
                label: 'Downloads',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined),
                activeIcon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
          );
        },
      ),
    );
  }
}

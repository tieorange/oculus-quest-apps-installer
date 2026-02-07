import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quest_game_manager/core/theme/app_theme.dart';
import 'package:quest_game_manager/features/catalog/presentation/bloc/catalog_bloc.dart';
import 'package:quest_game_manager/features/catalog/presentation/bloc/catalog_event.dart';
import 'package:quest_game_manager/features/catalog/presentation/pages/catalog_page.dart';
import 'package:quest_game_manager/features/downloads/presentation/bloc/downloads_bloc.dart';
import 'package:quest_game_manager/features/downloads/presentation/bloc/downloads_event.dart';
import 'package:quest_game_manager/features/downloads/presentation/pages/downloads_page.dart';
import 'package:quest_game_manager/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:quest_game_manager/features/settings/presentation/pages/settings_page.dart';
import 'package:quest_game_manager/injection.dart';

/// Root application widget.
class QuestGameManagerApp extends StatelessWidget {
  const QuestGameManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<CatalogBloc>()..add(const CatalogEvent.load())),
        BlocProvider(create: (_) => getIt<DownloadsBloc>()..add(const DownloadsEvent.loadQueue())),
        BlocProvider(create: (_) => getIt<SettingsCubit>()),
      ],
      child: MaterialApp(
        title: 'Quest Game Manager',
        theme: AppTheme.dark,
        debugShowCheckedModeBanner: false,
        home: const MainNavigation(),
      ),
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
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.games_outlined),
            activeIcon: Icon(Icons.games),
            label: 'Browse',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.download_outlined),
            activeIcon: Icon(Icons.download),
            label: 'Downloads',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

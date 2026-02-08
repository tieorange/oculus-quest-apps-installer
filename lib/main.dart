import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quest_game_manager/app.dart';
import 'package:quest_game_manager/features/catalog/data/models/cache_meta_model.dart';
import 'package:quest_game_manager/features/catalog/data/models/game_info_model.dart';
import 'package:quest_game_manager/injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for local storage
  await Hive.initFlutter();
  Hive
    ..registerAdapter(GameInfoModelAdapter())
    ..registerAdapter(CacheMetaModelAdapter());

  // Configure dependency injection
  await configureDependencies();

  runApp(const QuestGameManagerApp());
}

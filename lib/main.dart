import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quest_game_manager/app.dart';
import 'package:quest_game_manager/core/utils/app_logger.dart';
import 'package:quest_game_manager/features/catalog/data/models/game_info_model.dart';
import 'package:quest_game_manager/injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Global error handler
  FlutterError.onError = (details) {
    AppLogger.error(
      'Flutter error: ${details.exceptionAsString()}',
      tag: 'Global',
      stackTrace: details.stack,
    );
  };

  // Initialize Hive for local storage
  await Hive.initFlutter();
  Hive.registerAdapter(GameInfoModelAdapter());

  // Configure dependency injection
  await configureDependencies();

  runApp(const QuestGameManagerApp());
}

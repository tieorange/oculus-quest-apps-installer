import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'package:quest_game_manager/injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async => getIt.init();

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:quest_game_manager/core/constants/app_constants.dart';

/// Module for registering third-party dependencies.
@module
abstract class RegisterModule {
  @lazySingleton
  Dio get dio => Dio(
    BaseOptions(
      connectTimeout: AppConstants.connectTimeout,
      receiveTimeout: AppConstants.receiveTimeout,
      headers: {'User-Agent': AppConstants.userAgent},
    ),
  );
}

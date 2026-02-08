import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:native_dio_adapter/native_dio_adapter.dart';
import 'package:quest_game_manager/core/constants/app_constants.dart';

/// Module for registering third-party dependencies.
@module
abstract class RegisterModule {
  @lazySingleton
  Dio get dio {
    return Dio(
      BaseOptions(
        connectTimeout: AppConstants.connectTimeout,
        receiveTimeout: AppConstants.receiveTimeout,
        headers: {'User-Agent': AppConstants.userAgent},
      ),
    )..httpClientAdapter = NativeAdapter();
  }
}

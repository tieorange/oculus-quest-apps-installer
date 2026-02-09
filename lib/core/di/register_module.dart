import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:native_dio_adapter/native_dio_adapter.dart';
import 'package:quest_game_manager/core/constants/app_constants.dart';
import 'package:quest_game_manager/core/network/user_agent_interceptor.dart';

/// Module for registering third-party dependencies.
@module
abstract class RegisterModule {
  @lazySingleton
  Dio get dio {
    final dio = Dio(
      BaseOptions(
        connectTimeout: AppConstants.connectTimeout,
        receiveTimeout: AppConstants.receiveTimeout,
        headers: {'User-Agent': AppConstants.userAgent},
      ),
    )..httpClientAdapter = NativeAdapter();

    // Add interceptor to enforce User-Agent on all requests
    dio.interceptors.add(UserAgentInterceptor());

    return dio;
  }
}

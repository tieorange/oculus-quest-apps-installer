import 'package:dio/dio.dart';
import 'package:quest_game_manager/core/constants/app_constants.dart';

/// Interceptor that ensures all requests use the correct User-Agent header.
/// This prevents accidental overrides and centralizes User-Agent management.
class UserAgentInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Always set the User-Agent to the canonical value
    options.headers['User-Agent'] = AppConstants.userAgent;
    super.onRequest(options, handler);
  }
}

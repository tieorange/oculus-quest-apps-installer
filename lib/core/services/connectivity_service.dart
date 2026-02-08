import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:quest_game_manager/core/utils/app_logger.dart';

/// Service for monitoring network connectivity.
class ConnectivityService {
  ConnectivityService._();

  static final ConnectivityService instance = ConnectivityService._();

  final _controller = StreamController<bool>.broadcast();
  Timer? _pollingTimer;
  bool _lastKnownState = true;

  /// Stream of connectivity changes (true = online, false = offline).
  Stream<bool> get onConnectivityChanged => _controller.stream;

  /// Current connectivity state.
  bool get isOnline => _lastKnownState;

  /// Start monitoring connectivity by polling DNS resolution.
  void startMonitoring() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 10), (_) => _check());
    _check();
  }

  /// Stop monitoring.
  void stopMonitoring() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  Future<void> _check() async {
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 5));
      final online = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      if (online != _lastKnownState) {
        _lastKnownState = online;
        _controller.add(online);
        AppLogger.info(
          online ? 'Network: back online' : 'Network: went offline',
          tag: 'Connectivity',
        );
      }
    } catch (_) {
      if (_lastKnownState) {
        _lastKnownState = false;
        _controller.add(false);
        AppLogger.warning('Network: went offline', tag: 'Connectivity');
      }
    }
  }

  void dispose() {
    stopMonitoring();
    _controller.close();
  }
}

/// Widget that shows an offline banner when connectivity is lost.
class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: ConnectivityService.instance.onConnectivityChanged,
      initialData: ConnectivityService.instance.isOnline,
      builder: (context, snapshot) {
        final isOnline = snapshot.data ?? true;
        return AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
            color: Colors.red[900],
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.wifi_off, size: 16, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'No internet connection',
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
              ],
            ),
          ),
          crossFadeState: isOnline ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 300),
        );
      },
    );
  }
}

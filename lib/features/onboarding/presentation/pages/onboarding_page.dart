import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quest_game_manager/core/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Onboarding page shown on first launch for permission setup.
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({required this.onComplete, super.key});

  final VoidCallback onComplete;

  static const _prefsKey = 'onboarding_complete';

  static Future<bool> isComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_prefsKey) ?? false;
  }

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int _currentStep = 0;
  bool _storageGranted = false;
  bool _installGranted = false;

  Future<void> _markComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(OnboardingPage._prefsKey, true);
  }

  Future<void> _requestStoragePermission() async {
    final status = await Permission.manageExternalStorage.request();
    setState(() => _storageGranted = status.isGranted);
    if (status.isGranted) {
      setState(() => _currentStep = 1);
    }
  }

  Future<void> _requestInstallPermission() async {
    final status = await Permission.requestInstallPackages.request();
    setState(() => _installGranted = status.isGranted);
    if (status.isGranted) {
      setState(() => _currentStep = 2);
    }
  }

  Future<void> _finish() async {
    await _markComplete();
    widget.onComplete();
  }

  @override
  void initState() {
    super.initState();
    _checkExistingPermissions();
  }

  Future<void> _checkExistingPermissions() async {
    final storage = await Permission.manageExternalStorage.isGranted;
    final install = await Permission.requestInstallPackages.isGranted;
    setState(() {
      _storageGranted = storage;
      _installGranted = install;
      if (storage && install) {
        _currentStep = 2;
      } else if (storage) {
        _currentStep = 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              const Spacer(),
              const Icon(Icons.sports_esports, size: 80, color: Color(0xFF00D9FF)),
              const SizedBox(height: 24),
              Text(
                'Quest Game Manager',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Browse, download, and install Quest games',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              _buildStep(
                index: 0,
                icon: Icons.folder_open,
                title: 'Storage Access',
                description:
                    'Required to save downloaded games and manage OBB files on your device.',
                granted: _storageGranted,
                onRequest: _requestStoragePermission,
              ),
              const SizedBox(height: 16),
              _buildStep(
                index: 1,
                icon: Icons.install_mobile,
                title: 'Install Packages',
                description: 'Required to install downloaded game APKs on your Quest.',
                granted: _installGranted,
                onRequest: _requestInstallPermission,
              ),
              const SizedBox(height: 16),
              _buildStep(
                index: 2,
                icon: Icons.check_circle,
                title: 'All Set!',
                description: "You're ready to browse and install Quest games.",
                granted: _currentStep >= 2,
                onRequest: null,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _currentStep >= 2 ? _finish : null,
                  child: const Text('Get Started'),
                ),
              ),
              const SizedBox(height: 16),
              if (_currentStep < 2)
                TextButton(
                  onPressed: _finish,
                  child: Text(
                    'Skip for now',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep({
    required int index,
    required IconData icon,
    required String title,
    required String description,
    required bool granted,
    required VoidCallback? onRequest,
  }) {
    final isActive = index == _currentStep;
    final isPast = index < _currentStep || granted;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isPast
            ? AppTheme.success.withValues(alpha: 0.1)
            : isActive
                ? const Color(0xFF16213E)
                : const Color(0xFF0F0F1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPast
              ? AppTheme.success.withValues(alpha: 0.3)
              : isActive
                  ? const Color(0xFF00D9FF).withValues(alpha: 0.3)
                  : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isPast ? Icons.check_circle : icon,
            color: isPast ? AppTheme.success : (isActive ? const Color(0xFF00D9FF) : Colors.grey),
            size: 32,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: isPast || isActive ? Colors.white : Colors.grey,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),
          if (isActive && !granted && onRequest != null)
            TextButton(
              onPressed: onRequest,
              child: const Text('Grant'),
            ),
        ],
      ),
    );
  }
}

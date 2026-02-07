import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quest_game_manager/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:quest_game_manager/features/settings/presentation/widgets/settings_section.dart';
import 'package:quest_game_manager/features/settings/presentation/widgets/settings_tile.dart';

/// Settings page for app configuration.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(
        child: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                SettingsSection(
                  title: 'Downloads',
                  children: [
                    SettingsTile.switchTile(
                      leading: const Icon(Icons.refresh),
                      title: 'Auto-retry failed downloads',
                      value: state.autoRetryEnabled,
                      onChanged: (value) =>
                          context.read<SettingsCubit>().setAutoRetry(enabled: value),
                    ),
                    SettingsTile.switchTile(
                      leading: const Icon(Icons.notifications),
                      title: 'Download notifications',
                      value: state.notificationsEnabled,
                      onChanged: (value) =>
                          context.read<SettingsCubit>().setNotificationsEnabled(enabled: value),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SettingsSection(
                  title: 'Server Configuration',
                  children: [
                    SettingsTile.action(
                      leading: const Icon(Icons.settings_ethernet),
                      title: 'Manual Config Check',
                      subtitle: 'Override server configuration manually',
                      onTap: () => _showManualConfigDialog(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SettingsSection(
                  title: 'Storage',
                  children: [
                    SettingsTile.action(
                      leading: const Icon(Icons.delete_outline),
                      title: 'Clear cache',
                      subtitle: 'Remove downloaded game catalogs',
                      onTap: () => _showClearCacheDialog(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const SettingsSection(
                  title: 'About',
                  children: [
                    SettingsTile(
                      leading: Icon(Icons.info_outline),
                      title: 'Version',
                      trailing: Text('1.0.0'),
                    ),
                    SettingsTile(
                      leading: Icon(Icons.code),
                      title: 'Build',
                      trailing: Text('1'),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showClearCacheDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Clear Cache?'),
        content: const Text(
          'This will remove the downloaded game catalog. '
          'It will be re-downloaded next time you open the app.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              context.read<SettingsCubit>().clearCache();
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Cache cleared')));
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showManualConfigDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<SettingsCubit>(),
        child: BlocConsumer<SettingsCubit, SettingsState>(
          listenWhen: (previous, current) => previous.configSaveStatus != current.configSaveStatus,
          listener: (context, state) {
            if (state.configSaveStatus == ConfigSaveStatus.success) {
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Config saved successfully. Please restart app.')),
              );
              context.read<SettingsCubit>().resetConfigSaveStatus();
            } else if (state.configSaveStatus == ConfigSaveStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.configSaveError ?? 'Failed to save config'),
                  backgroundColor: Colors.red,
                ),
              );
              context.read<SettingsCubit>().resetConfigSaveStatus();
            }
          },
          builder: (context, state) {
            return AlertDialog(
              title: const Text('Manual Config'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Paste the content of vrp-public.json here to override the blocked server.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: controller,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      hintText: '{"baseUri": "...", "password": "..."}',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                if (state.configSaveStatus == ConfigSaveStatus.loading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: () {
                      final text = controller.text.trim();
                      if (text.isNotEmpty) {
                        context.read<SettingsCubit>().saveConfig(text);
                      }
                    },
                    child: const Text('Save'),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

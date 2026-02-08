import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quest_game_manager/core/constants/app_constants.dart';
import 'package:quest_game_manager/core/utils/file_utils.dart';
import 'package:quest_game_manager/features/downloads/data/datasources/download_stats_datasource.dart';
import 'package:quest_game_manager/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:quest_game_manager/features/settings/presentation/widgets/settings_section.dart';
import 'package:quest_game_manager/features/settings/presentation/widgets/storage_management_dialog.dart';
import 'package:quest_game_manager/features/settings/presentation/widgets/settings_tile.dart';
import 'package:quest_game_manager/injection.dart';

/// Settings page for app configuration.
/// Settings page for app configuration.
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    context.read<SettingsCubit>().loadDownloadsSize();
  }

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
                      leading: const Icon(Icons.download_done),
                      title: 'Auto-install after download',
                      value: state.autoInstallEnabled,
                      onChanged: (value) =>
                          context.read<SettingsCubit>().setAutoInstall(enabled: value),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SettingsSection(
                  title: 'Server Configuration',
                  children: [
                    SettingsTile.action(
                      leading: const Icon(Icons.settings_ethernet),
                      title: 'Manual Config Override',
                      subtitle: 'Paste vrp-public.json content',
                      onTap: () => _showManualConfigDialog(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SettingsSection(
                  title: 'Storage',
                  children: [
                    SettingsTile.action(
                      leading: const Icon(Icons.cleaning_services),
                      title: 'Manage Storage',
                      subtitle: 'View and delete installers & game data',
                      trailing: Text(
                        _formatSize(state.downloadsSize),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      onTap: () => StorageManagementDialog.show(context),
                    ),
                    _CacheSizeTile(),
                    SettingsTile.action(
                      leading: const Icon(Icons.delete_sweep),
                      title: 'Clear all cache',
                      subtitle: 'Remove downloaded archives and temp files',
                      onTap: () => _showClearCacheDialog(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const _DownloadStatsSection(),
                const SizedBox(height: 16),
                const SettingsSection(
                  title: 'About',
                  children: [
                    SettingsTile(
                      leading: Icon(Icons.info_outline),
                      title: 'Version',
                      trailing: Text(AppConstants.appVersion),
                    ),
                    SettingsTile(
                      leading: Icon(Icons.code),
                      title: 'Build',
                      trailing: Text(AppConstants.appBuild),
                    ),
                    SettingsTile(
                      leading: Icon(Icons.sports_esports),
                      title: 'Quest Game Manager',
                      subtitle: 'Browse, download & install Quest games',
                      trailing: SizedBox.shrink(),
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

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  void _showClearCacheDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Clear Cache?'),
        content: const Text(
          'This will remove all downloaded archives and temporary files. '
          'The game catalog will be re-downloaded on next refresh.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await context.read<SettingsCubit>().clearCache();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cache cleared successfully')),
                );
              }
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
                const SnackBar(content: Text('Config saved. Restart app to apply.')),
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
                    'Paste vrp-public.json content to override the server configuration.',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
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

class _CacheSizeTile extends StatefulWidget {
  @override
  State<_CacheSizeTile> createState() => _CacheSizeTileState();
}

class _CacheSizeTileState extends State<_CacheSizeTile> {
  String _cacheSize = 'Calculating...';

  @override
  void initState() {
    super.initState();
    _loadCacheSize();
  }

  Future<void> _loadCacheSize() async {
    final size = await FileUtils.getCacheSize();
    if (mounted) {
      setState(() => _cacheSize = FileUtils.formatBytes(size));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SettingsTile(
      leading: const Icon(Icons.folder),
      title: 'Cache size',
      trailing: Text(_cacheSize, style: Theme.of(context).textTheme.bodySmall),
    );
  }
}

class _DownloadStatsSection extends StatefulWidget {
  const _DownloadStatsSection();

  @override
  State<_DownloadStatsSection> createState() => _DownloadStatsSectionState();
}

class _DownloadStatsSectionState extends State<_DownloadStatsSection> {
  DownloadStats? _stats;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final datasource = getIt<DownloadStatsDatasource>();
    final stats = await datasource.getStats();
    if (mounted) setState(() => _stats = stats);
  }

  @override
  Widget build(BuildContext context) {
    final stats = _stats;
    return SettingsSection(
      title: 'Download Statistics',
      children: [
        SettingsTile(
          leading: const Icon(Icons.cloud_download),
          title: 'Total downloaded',
          trailing: Text(
            stats?.totalFormatted ?? '...',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        SettingsTile(
          leading: const Icon(Icons.games),
          title: 'Games installed',
          trailing: Text(
            '${stats?.totalGamesInstalled ?? 0}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        SettingsTile(
          leading: const Icon(Icons.speed),
          title: 'Average speed',
          trailing: Text(
            stats?.avgSpeedFormatted ?? '...',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        SettingsTile(
          leading: const Icon(Icons.trending_up),
          title: 'Peak speed',
          trailing: Text(
            stats?.peakSpeedFormatted ?? '...',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        SettingsTile(
          leading: const Icon(Icons.today),
          title: 'This session',
          trailing: Text(
            stats != null
                ? '${stats.sessionGamesInstalled} games, ${stats.sessionFormatted}'
                : '...',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}

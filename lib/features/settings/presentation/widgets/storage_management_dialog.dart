import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quest_game_manager/core/utils/file_utils.dart';
import 'package:quest_game_manager/features/downloads/domain/entities/storage_item.dart';
import 'package:quest_game_manager/features/settings/presentation/cubit/settings_cubit.dart';

/// Dialog for managing storage (installers and OBBs) with multi-selection.
class StorageManagementDialog extends StatefulWidget {
  const StorageManagementDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<SettingsCubit>()..loadStorageItems(),
        child: const StorageManagementDialog(),
      ),
    );
  }

  @override
  State<StorageManagementDialog> createState() => _StorageManagementDialogState();
}

class _StorageManagementDialogState extends State<StorageManagementDialog> {
  final Set<String> _selectedIds = {};

  void _toggleSelection(StorageItem item) {
    setState(() {
      if (_selectedIds.contains(item.id)) {
        _selectedIds.remove(item.id);
      } else {
        _selectedIds.add(item.id);
      }
    });
  }

  void _selectAll(List<StorageItem> items) {
    setState(() {
      _selectedIds.addAll(items.map((i) => i.id));
    });
  }

  void _deselectAll() {
    setState(() {
      _selectedIds.clear();
    });
  }

  void _deleteSelected(BuildContext context, List<StorageItem> items) {
    final selectedItems = items.where((i) => _selectedIds.contains(i.id)).toList();
    if (selectedItems.isEmpty) return;

    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Delete ${selectedItems.length} item(s)?\nThis cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true) {
        context.read<SettingsCubit>().deleteStorageItems(selectedItems);
        _selectedIds.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final items = state.storageItems;
        final isLoading = state.storageLoadStatus == StorageLoadStatus.loading ||
            state.clearingStatus == ClearingStatus.loading;
        final totalSize = items.fold<int>(0, (sum, i) => sum + i.sizeBytes);
        final selectedSize = items
            .where((i) => _selectedIds.contains(i.id))
            .fold<int>(0, (sum, i) => sum + i.sizeBytes);

        return AlertDialog(
          title: Row(
            children: [
              const Expanded(child: Text('Storage Management')),
              if (isLoading)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Summary
                Text(
                  'Total: ${FileUtils.formatBytes(totalSize)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (_selectedIds.isNotEmpty)
                  Text(
                    'Selected: ${_selectedIds.length} items (${FileUtils.formatBytes(selectedSize)})',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                const SizedBox(height: 8),
                // Select All / Deselect All
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: items.isEmpty ? null : () => _selectAll(items),
                      icon: const Icon(Icons.select_all, size: 18),
                      label: const Text('All'),
                    ),
                    TextButton.icon(
                      onPressed: _selectedIds.isEmpty ? null : _deselectAll,
                      icon: const Icon(Icons.deselect, size: 18),
                      label: const Text('None'),
                    ),
                  ],
                ),
                const Divider(height: 1),
                // List
                Expanded(
                  child: items.isEmpty
                      ? Center(
                          child: isLoading
                              ? const CircularProgressIndicator()
                              : const Text('No storage items found'),
                        )
                      : ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (ctx, index) {
                            final item = items[index];
                            final isSelected = _selectedIds.contains(item.id);
                            return CheckboxListTile(
                              value: isSelected,
                              onChanged: (_) => _toggleSelection(item),
                              title: Text(
                                item.label,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Row(
                                children: [
                                  _TypeBadge(type: item.type),
                                  const SizedBox(width: 8),
                                  Text(FileUtils.formatBytes(item.sizeBytes)),
                                ],
                              ),
                              dense: true,
                              controlAffinity: ListTileControlAffinity.leading,
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
            FilledButton.icon(
              onPressed:
                  _selectedIds.isEmpty || isLoading ? null : () => _deleteSelected(context, items),
              icon: const Icon(Icons.delete_outline),
              label: const Text('Delete Selected'),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.type});
  final StorageItemType type;

  @override
  Widget build(BuildContext context) {
    final isInstaller = type == StorageItemType.installer;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: (isInstaller ? Colors.blue : Colors.green).withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        isInstaller ? 'Installer' : 'Game Data',
        style: TextStyle(
          fontSize: 10,
          color: isInstaller ? Colors.blue : Colors.green,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

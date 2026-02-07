import 'package:flutter/material.dart';

/// Reusable settings tile widget.
class SettingsTile extends StatelessWidget {
  const SettingsTile({
    required this.title,
    this.leading,
    this.subtitle,
    this.trailing,
    this.onTap,
    super.key,
  });

  /// Factory for switch tiles.
  factory SettingsTile.switchTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
    Widget? leading,
    String? subtitle,
  }) {
    return SettingsTile(
      leading: leading,
      title: title,
      subtitle: subtitle,
      trailing: Switch.adaptive(value: value, onChanged: onChanged),
      onTap: () => onChanged(!value),
    );
  }

  /// Factory for action tiles.
  factory SettingsTile.action({
    required String title,
    required VoidCallback onTap,
    Widget? leading,
    String? subtitle,
  }) {
    return SettingsTile(
      leading: leading,
      title: title,
      subtitle: subtitle,
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  final Widget? leading;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: trailing,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}

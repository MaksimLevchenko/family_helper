import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

class AppTile extends StatelessWidget {
  const AppTile({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Card(
      child: ListTile(
        onTap: onTap,
        title: Text(title, style: TextStyle(color: colors.textPrimary)),
        subtitle: subtitle == null
            ? null
            : Text(subtitle!, style: TextStyle(color: colors.textSecondary)),
        trailing: trailing,
      ),
    );
  }
}

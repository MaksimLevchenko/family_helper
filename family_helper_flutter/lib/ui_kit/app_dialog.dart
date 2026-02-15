import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import 'app_button.dart';

class AppDialog extends StatelessWidget {
  const AppDialog({
    super.key,
    required this.title,
    required this.message,
    required this.confirmLabel,
    this.cancelLabel = 'Cancel',
    this.onCancel,
    required this.onConfirm,
  });

  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final VoidCallback? onCancel;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AlertDialog(
      backgroundColor: colors.surface,
      title: Text(title, style: TextStyle(color: colors.textPrimary)),
      content: Text(message, style: TextStyle(color: colors.textSecondary)),
      actions: [
        TextButton(
          onPressed: onCancel ?? () => Navigator.of(context).pop(),
          child: Text(cancelLabel, style: TextStyle(color: colors.textSecondary)),
        ),
        SizedBox(
          width: 120,
          child: AppButton(label: confirmLabel, onPressed: onConfirm),
        ),
      ],
    );
  }
}

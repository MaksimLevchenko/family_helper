import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

class AppBanner extends StatelessWidget {
  const AppBanner({
    super.key,
    required this.text,
    this.isError = false,
  });

  final String text;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isError ? colors.danger : colors.surfaceMuted,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isError ? colors.background : colors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

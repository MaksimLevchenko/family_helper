import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

class LoadingState extends StatelessWidget {
  const LoadingState({super.key, this.label = 'Loading...'});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: colors.primary),
          const SizedBox(height: 12),
          Text(label, style: TextStyle(color: colors.textSecondary)),
        ],
      ),
    );
  }
}

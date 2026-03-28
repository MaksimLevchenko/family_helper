import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

part 'startup_loading_screen_parts.dart';

class StartupLoadingScreen extends StatefulWidget {
  const StartupLoadingScreen({
    super.key,
    required this.title,
    required this.message,
    this.isLoading = true,
  });

  final String title;
  final String message;
  final bool isLoading;

  @override
  State<StartupLoadingScreen> createState() => _StartupLoadingScreenState();
}

class _StartupLoadingScreenState extends State<StartupLoadingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final isDark = theme.brightness == Brightness.dark;

    final gradientColors = isDark
        ? [
            const Color(0xFF041E20),
            const Color(0xFF0A3537),
            const Color(0xFF13605A),
          ]
        : [
            const Color(0xFFF7FFFD),
            const Color(0xFFE5FBF5),
            const Color(0xFFC3ECE2),
          ];

    final spotlightColor = isDark
        ? const Color(0xFF8BE1D0).withValues(alpha: 0.14)
        : const Color(0xFF13605A).withValues(alpha: 0.10);
    final orbColor = isDark
        ? Colors.white.withValues(alpha: 0.05)
        : colors.primary.withValues(alpha: 0.10);
    final cardGradient = isDark
        ? [
            const Color(0xFF0B2224).withValues(alpha: 0.84),
            const Color(0xFF09181A).withValues(alpha: 0.76),
          ]
        : [
            Colors.white.withValues(alpha: 0.78),
            Colors.white.withValues(alpha: 0.58),
          ];
    final cardBorderColor = isDark
        ? Colors.white.withValues(alpha: 0.12)
        : Colors.white.withValues(alpha: 0.64);
    final dividerColor = isDark
        ? Colors.white.withValues(alpha: 0.09)
        : colors.primary.withValues(alpha: 0.10);

    return _buildStartupLoadingLayout(
      context: context,
      controller: _controller,
      title: widget.title,
      message: widget.message,
      isLoading: widget.isLoading,
      isDark: isDark,
      theme: theme,
      colors: colors,
      gradientColors: gradientColors,
      spotlightColor: spotlightColor,
      orbColor: orbColor,
      cardGradient: cardGradient,
      cardBorderColor: cardBorderColor,
      dividerColor: dividerColor,
    );
  }
}

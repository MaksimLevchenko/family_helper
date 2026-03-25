import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

class StartupLoadingScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final isDark = theme.brightness == Brightness.dark;

    final gradientColors = isDark
        ? [
            const Color(0xFF062A2A),
            const Color(0xFF0B3E3C),
            const Color(0xFF13605A),
          ]
        : [
            const Color(0xFFF3FFFC),
            const Color(0xFFDDF7F1),
            const Color(0xFFB7E6DD),
          ];

    final orbColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : colors.primary.withValues(alpha: 0.12);
    final cardColor = isDark
        ? Colors.black.withValues(alpha: 0.16)
        : Colors.white.withValues(alpha: 0.58);

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -72,
              right: -48,
              child: _BackgroundOrb(size: 220, color: orbColor),
            ),
            Positioned(
              bottom: -110,
              left: -60,
              child: _BackgroundOrb(size: 260, color: orbColor),
            ),
            SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 360),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.35),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 32,
                            offset: const Offset(0, 18),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 32,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                color: colors.primary.withValues(alpha: 0.14),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.favorite_rounded,
                                size: 36,
                                color: colors.primary,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              title,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.headlineMedium?.copyWith(
                                color: colors.textPrimary,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.4,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              message,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colors.textSecondary,
                                height: 1.45,
                              ),
                            ),
                            const SizedBox(height: 24),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 180),
                              child: isLoading
                                  ? SizedBox(
                                      key: const ValueKey('progress'),
                                      width: 28,
                                      height: 28,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 3,
                                        color: colors.primary,
                                      ),
                                    )
                                  : Icon(
                                      key: const ValueKey('error'),
                                      Icons.error_outline_rounded,
                                      size: 28,
                                      color: theme.colorScheme.error,
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BackgroundOrb extends StatelessWidget {
  const _BackgroundOrb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}

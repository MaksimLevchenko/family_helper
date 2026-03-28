import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

part 'loading_state_parts.dart';

class LoadingState extends StatefulWidget {
  const LoadingState({super.key, this.label = 'Loading...'});

  final String label;

  @override
  State<LoadingState> createState() => _LoadingStateState();
}

class _LoadingStateState extends State<LoadingState>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
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

    final surfaceGradient = isDark
        ? [
            const Color(0xFF0D2427),
            const Color(0xFF0A1B1D),
          ]
        : [
            Colors.white.withValues(alpha: 0.92),
            const Color(0xFFF6FCFA).withValues(alpha: 0.92),
          ];
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.white.withValues(alpha: 0.78);
    final ambientColor = colors.primary.withValues(alpha: isDark ? 0.16 : 0.10);
    final panelShadowColor = Colors.black.withValues(
      alpha: isDark ? 0.22 : 0.08,
    );

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final progress = _controller.value;
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: -24,
                    right: -12,
                    child: _AmbientOrb(
                      size: 110,
                      color: ambientColor,
                    ),
                  ),
                  Positioned(
                    bottom: -30,
                    left: -16,
                    child: _AmbientOrb(
                      size: 90,
                      color: colors.secondary.withValues(
                        alpha: isDark ? 0.10 : 0.08,
                      ),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: surfaceGradient,
                          ),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(color: borderColor),
                          boxShadow: [
                            BoxShadow(
                              color: panelShadowColor,
                              blurRadius: 28,
                              offset: const Offset(0, 16),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _LoadingBadge(
                                progress: progress,
                                primary: colors.primary,
                              ),
                              const SizedBox(height: 18),
                              Text(
                                widget.label,
                                textAlign: TextAlign.center,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: colors.textPrimary,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.2,
                                ),
                              ),
                              const SizedBox(height: 18),
                              _LoadingTrack(
                                progress: progress,
                                primary: colors.primary,
                                trackColor: colors.primary.withValues(
                                  alpha: isDark ? 0.16 : 0.10,
                                ),
                              ),
                              const SizedBox(height: 14),
                              _LoadingDots(
                                progress: progress,
                                primary: colors.primary,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

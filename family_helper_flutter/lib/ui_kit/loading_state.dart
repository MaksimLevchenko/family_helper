import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

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

class _LoadingBadge extends StatelessWidget {
  const _LoadingBadge({
    required this.progress,
    required this.primary,
  });

  final double progress;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    final pulse = (math.sin(progress * math.pi * 2) + 1) / 2;
    final angle = (progress * math.pi * 2) - (math.pi / 2);

    return SizedBox(
      width: 88,
      height: 88,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 78 + (pulse * 8),
            height: 78 + (pulse * 8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  primary.withValues(alpha: 0.18),
                  primary.withValues(alpha: 0.02),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  primary.withValues(alpha: 0.92),
                  primary,
                ],
              ),
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: primary.withValues(alpha: 0.24),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.hourglass_bottom_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
          Transform.translate(
            offset: Offset(math.cos(angle) * 34, math.sin(angle) * 34),
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: primary.withValues(alpha: 0.18),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingTrack extends StatelessWidget {
  const _LoadingTrack({
    required this.progress,
    required this.primary,
    required this.trackColor,
  });

  final double progress;
  final Color primary;
  final Color trackColor;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: SizedBox(
        width: 164,
        height: 6,
        child: Stack(
          children: [
            ColoredBox(color: trackColor),
            Align(
              alignment: Alignment(-1.3 + (progress * 2.6), 0),
              child: FractionallySizedBox(
                widthFactor: 0.5,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        primary.withValues(alpha: 0.18),
                        primary.withValues(alpha: 0.95),
                        Colors.white.withValues(alpha: 0.90),
                      ],
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

class _LoadingDots extends StatelessWidget {
  const _LoadingDots({
    required this.progress,
    required this.primary,
  });

  final double progress;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        final phase = ((progress + (index * 0.14)) % 1.0) * math.pi * 2;
        final value = (math.sin(phase) + 1) / 2;
        return Container(
          width: 8 + (value * 6),
          height: 8 + (value * 6),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: primary.withValues(alpha: 0.34 + (value * 0.56)),
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
}

class _AmbientOrb extends StatelessWidget {
  const _AmbientOrb({
    required this.size,
    required this.color,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

part of 'startup_loading_screen.dart';

Widget _buildStartupLoadingLayout({
  required BuildContext context,
  required AnimationController controller,
  required String title,
  required String message,
  required bool isLoading,
  required bool isDark,
  required ThemeData theme,
  required AppColors colors,
  required List<Color> gradientColors,
  required Color spotlightColor,
  required Color orbColor,
  required List<Color> cardGradient,
  required Color cardBorderColor,
  required Color dividerColor,
}) {
  return AnimatedBuilder(
    animation: controller,
    builder: (context, _) {
      final t = controller.value;

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
              Positioned.fill(
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment(0.88 - (t * 0.32), -0.96),
                        radius: 0.72,
                        colors: [
                          spotlightColor,
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: -64 + (math.sin(t * math.pi * 2) * 10),
                right: -44,
                child: _BackgroundOrb(size: 220, color: orbColor),
              ),
              Positioned(
                bottom: -118,
                left: -54 + (math.cos(t * math.pi * 2) * 8),
                child: _BackgroundOrb(size: 260, color: orbColor),
              ),
              Positioned(
                top: 116,
                left: 28,
                child: _BackgroundOrb(
                  size: 88,
                  color: colors.primary.withValues(
                    alpha: isDark ? 0.08 : 0.12,
                  ),
                ),
              ),
              SafeArea(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 392),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: cardGradient,
                              ),
                              borderRadius: BorderRadius.circular(32),
                              border: Border.all(color: cardBorderColor),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(
                                    alpha: isDark ? 0.24 : 0.10,
                                  ),
                                  blurRadius: 40,
                                  offset: const Offset(0, 24),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                28,
                                30,
                                28,
                                26,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _AnimatedBadge(
                                    progress: t,
                                    primary: colors.primary,
                                    glowColor: spotlightColor,
                                  ),
                                  const SizedBox(height: 24),
                                  Text(
                                    title,
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.headlineMedium
                                        ?.copyWith(
                                          color: colors.textPrimary,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: -0.6,
                                        ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    message,
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: colors.textSecondary,
                                      height: 1.55,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 220),
                                    switchInCurve: Curves.easeOutCubic,
                                    switchOutCurve: Curves.easeInCubic,
                                    child: isLoading
                                        ? Column(
                                            key: const ValueKey('progress'),
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              _ProgressTrack(
                                                progress: t,
                                                primary: colors.primary,
                                                trackColor: dividerColor,
                                              ),
                                              const SizedBox(height: 14),
                                              _LoaderDots(
                                                progress: t,
                                                primary: colors.primary,
                                              ),
                                            ],
                                          )
                                        : Container(
                                            key: const ValueKey('error'),
                                            width: 56,
                                            height: 56,
                                            decoration: BoxDecoration(
                                              color: theme.colorScheme
                                                  .errorContainer,
                                              shape: BoxShape.circle,
                                            ),
                                            alignment: Alignment.center,
                                            child: Icon(
                                              Icons.error_outline_rounded,
                                              size: 28,
                                              color: theme.colorScheme.error,
                                            ),
                                          ),
                                  ),
                                  const SizedBox(height: 22),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: colors.primary.withValues(
                                        alpha: isDark ? 0.10 : 0.08,
                                      ),
                                      borderRadius: BorderRadius.circular(18),
                                      border: Border.all(color: dividerColor),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          isLoading
                                              ? Icons.auto_awesome_rounded
                                              : Icons.shield_outlined,
                                          size: 18,
                                          color: colors.primary,
                                        ),
                                        const SizedBox(width: 8),
                                        Flexible(
                                          child: Text(
                                            isLoading
                                                ? 'Bringing your family space online'
                                                : 'We hit a snag while opening your space',
                                            textAlign: TextAlign.center,
                                            style: theme.textTheme.bodySmall
                                                ?.copyWith(
                                                  color: colors.textSecondary,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 0.1,
                                                ),
                                          ),
                                        ),
                                      ],
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
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _AnimatedBadge extends StatelessWidget {
  const _AnimatedBadge({
    required this.progress,
    required this.primary,
    required this.glowColor,
  });

  final double progress;
  final Color primary;
  final Color glowColor;

  @override
  Widget build(BuildContext context) {
    final pulse = (math.sin(progress * math.pi * 2) + 1) / 2;
    final orbitAngle = (progress * math.pi * 2) - (math.pi / 2);
    final orbitRadius = 54.0;

    return SizedBox(
      width: 132,
      height: 132,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 116 + (pulse * 12),
            height: 116 + (pulse * 12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  glowColor.withValues(alpha: 0.64),
                  glowColor.withValues(alpha: 0.08),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          Container(
            width: 108,
            height: 108,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: primary.withValues(alpha: 0.14 + (pulse * 0.14)),
                width: 1.5,
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(
              math.cos(orbitAngle) * orbitRadius,
              math.sin(orbitAngle) * orbitRadius,
            ),
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.95),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: primary.withValues(alpha: 0.28),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  primary.withValues(alpha: 0.88),
                  primary,
                ],
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: primary.withValues(alpha: 0.26 + (pulse * 0.12)),
                  blurRadius: 26,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.favorite_rounded,
              size: 40,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressTrack extends StatelessWidget {
  const _ProgressTrack({
    required this.progress,
    required this.primary,
    required this.trackColor,
  });

  final double progress;
  final Color primary;
  final Color trackColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 164,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(999),
        child: Stack(
          children: [
            Container(
              height: 6,
              color: trackColor,
            ),
            Align(
              alignment: Alignment(-1.35 + (progress * 2.7), 0),
              child: FractionallySizedBox(
                widthFactor: 0.52,
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    gradient: LinearGradient(
                      colors: [
                        primary.withValues(alpha: 0.15),
                        primary.withValues(alpha: 0.95),
                        Colors.white.withValues(alpha: 0.92),
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

class _LoaderDots extends StatelessWidget {
  const _LoaderDots({
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
        final phase = ((progress + (index * 0.16)) % 1.0) * math.pi * 2;
        final value = (math.sin(phase) + 1) / 2;
        return Container(
          width: 10 + (value * 5),
          height: 10 + (value * 5),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: primary.withValues(alpha: 0.34 + (value * 0.56)),
            shape: BoxShape.circle,
          ),
        );
      }),
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

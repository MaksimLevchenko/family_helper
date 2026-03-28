part of 'loading_state.dart';

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

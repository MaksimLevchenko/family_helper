import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../ui_kit/server_status_app_bar.dart';

class AuthFlowScaffold extends StatelessWidget {
  const AuthFlowScaffold({
    required this.cardTitle,
    required this.cardSubtitle,
    required this.child,
    this.cardEyebrow,
    this.progressStep,
    this.progressTotal,
    super.key,
  });

  final String cardTitle;
  final String cardSubtitle;
  final Widget child;
  final String? cardEyebrow;
  final int? progressStep;
  final int? progressTotal;

  static const compactLayoutKey = ValueKey('auth-compact-layout');
  static const wideLayoutKey = ValueKey('auth-wide-layout');

  bool get _showProgress =>
      progressStep != null &&
      progressTotal != null &&
      progressTotal! > 0 &&
      progressStep! > 0;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: serverStatusAppBar(
        context,
        toolbarHeight: 0,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: colors.background,
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colors.background,
              colors.surfaceMuted.withValues(alpha: isDark ? 0.24 : 0.52),
              colors.background,
            ],
            stops: const [0, 0.45, 1],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -120,
              left: -40,
              child: _BackgroundOrb(
                size: 260,
                color: colors.primary.withValues(alpha: isDark ? 0.16 : 0.12),
              ),
            ),
            Positioned(
              top: 160,
              right: -70,
              child: _BackgroundOrb(
                size: 220,
                color: colors.secondary.withValues(
                  alpha: isDark ? 0.10 : 0.08,
                ),
              ),
            ),
            Positioned(
              bottom: -90,
              left: 40,
              child: _BackgroundOrb(
                size: 200,
                color: colors.success.withValues(alpha: isDark ? 0.11 : 0.09),
              ),
            ),
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 920;
                  if (isWide) {
                    return Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1240),
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Row(
                            key: wideLayoutKey,
                            children: [
                              Expanded(
                                flex: 6,
                                child: _EntranceMotion(
                                  delay: const Duration(milliseconds: 40),
                                  child: const _AuthHeroPanel(),
                                ),
                              ),
                              const SizedBox(width: 28),
                              Expanded(
                                flex: 5,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: _EntranceMotion(
                                    delay: const Duration(milliseconds: 120),
                                    child: _AuthCard(
                                      maxWidth: 500,
                                      cardEyebrow: cardEyebrow,
                                      cardTitle: cardTitle,
                                      cardSubtitle: cardSubtitle,
                                      progressStep: progressStep,
                                      progressTotal: progressTotal,
                                      showProgress: _showProgress,
                                      child: child,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    key: compactLayoutKey,
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 560),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _EntranceMotion(
                              delay: const Duration(milliseconds: 40),
                              child: const _AuthHeroPanel(isCompact: true),
                            ),
                            const SizedBox(height: 24),
                            _EntranceMotion(
                              delay: const Duration(milliseconds: 120),
                              child: _AuthCard(
                                cardEyebrow: cardEyebrow,
                                cardTitle: cardTitle,
                                cardSubtitle: cardSubtitle,
                                progressStep: progressStep,
                                progressTotal: progressTotal,
                                showProgress: _showProgress,
                                child: child,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AuthHeroPanel extends StatelessWidget {
  const _AuthHeroPanel({this.isCompact = false});

  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final isDark = theme.brightness == Brightness.dark;

    final titleStyle =
        (isCompact
                ? theme.textTheme.headlineMedium
                : theme.textTheme.displaySmall)
            ?.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.8,
              height: 1.02,
            );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: colors.surface.withValues(alpha: isDark ? 0.56 : 0.74),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: colors.border.withValues(alpha: isDark ? 0.42 : 0.70),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: colors.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: colors.primary.withValues(alpha: 0.28),
                      blurRadius: 12,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Family Helper',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: isCompact ? 22 : 30),
        Text(
          'Calm planning for busy families.',
          style: titleStyle,
        ),
        const SizedBox(height: 14),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: isCompact ? 520 : 460),
          child: Text(
            'Keep routines, lists, goals, and important dates together in one warm, shared space.',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colors.textSecondary,
              height: 1.45,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(height: isCompact ? 20 : 28),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: const [
            _HeroPill(
              icon: Icons.event_available_rounded,
              label: 'Shared calendar rhythm',
            ),
            _HeroPill(
              icon: Icons.task_alt_rounded,
              label: 'Household tasks in sync',
            ),
            _HeroPill(
              icon: Icons.savings_rounded,
              label: 'Goals everyone can follow',
            ),
          ],
        ),
      ],
    );
  }
}

class _HeroPill extends StatelessWidget {
  const _HeroPill({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.border.withValues(alpha: 0.64)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 280),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: colors.primary),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  label,
                  softWrap: true,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AuthCard extends StatelessWidget {
  const _AuthCard({
    required this.cardTitle,
    required this.cardSubtitle,
    required this.child,
    required this.showProgress,
    this.cardEyebrow,
    this.progressStep,
    this.progressTotal,
    this.maxWidth,
  });

  final String cardTitle;
  final String cardSubtitle;
  final Widget child;
  final String? cardEyebrow;
  final int? progressStep;
  final int? progressTotal;
  final bool showProgress;
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final isDark = theme.brightness == Brightness.dark;
    final panelGradient = isDark
        ? [
            colors.surface.withValues(alpha: 0.82),
            colors.surfaceMuted.withValues(alpha: 0.70),
          ]
        : [
            Colors.white.withValues(alpha: 0.92),
            colors.surface.withValues(alpha: 0.92),
          ];

    final cardChild = ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: panelGradient,
            ),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: colors.border.withValues(alpha: isDark ? 0.34 : 0.52),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.20 : 0.10),
                blurRadius: 34,
                offset: const Offset(0, 18),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (cardEyebrow != null) ...[
                  Text(
                    cardEyebrow!,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
                Text(
                  cardTitle,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  cardSubtitle,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colors.textSecondary,
                    height: 1.4,
                  ),
                ),
                if (showProgress) ...[
                  const SizedBox(height: 18),
                  _StepProgress(
                    step: progressStep!,
                    total: progressTotal!,
                  ),
                ],
                const SizedBox(height: 24),
                child,
              ],
            ),
          ),
        ),
      ),
    );

    if (maxWidth == null) {
      return cardChild;
    }

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth!),
      child: cardChild,
    );
  }
}

class _StepProgress extends StatelessWidget {
  const _StepProgress({
    required this.step,
    required this.total,
  });

  final int step;
  final int total;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Step $step of $total',
          style: theme.textTheme.labelMedium?.copyWith(
            color: colors.textSecondary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            minHeight: 8,
            value: step / total,
            backgroundColor: colors.surfaceMuted,
            valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
          ),
        ),
      ],
    );
  }
}

class _BackgroundOrb extends StatelessWidget {
  const _BackgroundOrb({
    required this.size,
    required this.color,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                color,
                color.withValues(alpha: color.a * 0.38),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EntranceMotion extends StatefulWidget {
  const _EntranceMotion({
    required this.child,
    this.delay = Duration.zero,
  });

  final Widget child;
  final Duration delay;

  @override
  State<_EntranceMotion> createState() => _EntranceMotionState();
}

class _EntranceMotionState extends State<_EntranceMotion>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _offset;
  Timer? _startTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 620),
    );
    final curved = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _opacity = Tween<double>(begin: 0, end: 1).animate(curved);
    _offset = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(curved);

    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      _startTimer = Timer(widget.delay, _controller.forward);
    }
  }

  @override
  void dispose() {
    _startTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _offset,
        child: widget.child,
      ),
    );
  }
}

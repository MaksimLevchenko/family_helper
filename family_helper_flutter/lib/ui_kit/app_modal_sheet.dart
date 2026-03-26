import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

class AppModalSheet extends StatelessWidget {
  const AppModalSheet({
    super.key,
    required this.child,
    this.contentPadding = const EdgeInsets.fromLTRB(20, 20, 20, 20),
    this.maxWidth = 640,
    this.maxHeightFactor = 0.92,
    this.horizontalMargin = 12,
    this.topMargin = 12,
    this.showHandle = true,
    this.scrollable = true,
    this.includeBottomSafeArea = true,
    this.backgroundColor,
    this.borderRadius = const BorderRadius.vertical(top: Radius.circular(32)),
  });

  final Widget child;
  final EdgeInsets contentPadding;
  final double maxWidth;
  final double maxHeightFactor;
  final double horizontalMargin;
  final double topMargin;
  final bool showHandle;
  final bool scrollable;
  final bool includeBottomSafeArea;
  final Color? backgroundColor;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final safeArea = MediaQuery.paddingOf(context);
    final colors = context.colors;
    final bottomSafeArea = includeBottomSafeArea ? safeArea.bottom : 0.0;
    final resolvedPadding = contentPadding.copyWith(
      bottom: contentPadding.bottom + bottomSafeArea,
    );

    final content = scrollable
        ? SingleChildScrollView(
            padding: resolvedPadding,
            child: child,
          )
        : Padding(
            padding: resolvedPadding,
            child: child,
          );

    return AnimatedPadding(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      padding: EdgeInsets.fromLTRB(
        horizontalMargin,
        topMargin,
        horizontalMargin,
        mediaQuery.viewInsets.bottom,
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxWidth,
            maxHeight: mediaQuery.size.height * maxHeightFactor,
          ),
          child: Material(
            color: backgroundColor ?? colors.background,
            elevation: 4,
            shadowColor: Colors.black.withValues(alpha: 0.16),
            borderRadius: borderRadius,
            clipBehavior: Clip.antiAlias,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (showHandle) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: colors.border,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                Flexible(
                  fit: FlexFit.loose,
                  child: content,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

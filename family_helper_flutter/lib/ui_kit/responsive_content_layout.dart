import 'package:flutter/material.dart';

class ResponsiveContentLayout extends StatelessWidget {
  const ResponsiveContentLayout({
    required this.builder,
    this.wideBreakpoint = 920,
    this.maxWidth = 1120,
    this.narrowPadding = const EdgeInsets.all(16),
    this.widePadding = const EdgeInsets.all(24),
    super.key,
  });

  final Widget Function(BuildContext context, bool isWide) builder;
  final double wideBreakpoint;
  final double maxWidth;
  final EdgeInsetsGeometry narrowPadding;
  final EdgeInsetsGeometry widePadding;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= wideBreakpoint;

          return Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isWide ? maxWidth : double.infinity,
              ),
              child: SingleChildScrollView(
                padding: isWide ? widePadding : narrowPadding,
                child: builder(context, isWide),
              ),
            ),
          );
        },
      ),
    );
  }
}

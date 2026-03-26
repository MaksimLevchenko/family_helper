import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/network/server_availability_cubit.dart';
import '../core/theme/app_colors.dart';

const _serverUnavailableBannerText =
    'Server unavailable. Some actions may not work until connection is restored.';

AppBar serverStatusAppBar(
  BuildContext context, {
  Widget? title,
  Widget? leading,
  List<Widget>? actions,
  PreferredSizeWidget? bottom,
  double? toolbarHeight,
  bool automaticallyImplyLeading = true,
}) {
  final serverAvailabilityState =
      context.watch<ServerAvailabilityCubit?>()?.state ??
      const ServerAvailabilityState(
        status: ServerAvailabilityStatus.available,
      );
  final availabilityBottom = serverAvailabilityState.isUnavailable
      ? const _ServerStatusBanner()
      : null;

  return AppBar(
    title: title,
    leading: leading,
    actions: actions,
    toolbarHeight: toolbarHeight,
    automaticallyImplyLeading: automaticallyImplyLeading,
    bottom: switch ((bottom, availabilityBottom)) {
      (null, null) => null,
      (final existingBottom?, null) => existingBottom,
      (null, final availabilityBottom?) => availabilityBottom,
      (final existingBottom?, final availabilityBottom?) =>
        _CombinedAppBarBottom(
          children: [existingBottom, availabilityBottom],
        ),
    },
  );
}

class _CombinedAppBarBottom extends StatelessWidget
    implements PreferredSizeWidget {
  const _CombinedAppBarBottom({required this.children});

  final List<PreferredSizeWidget> children;

  @override
  Size get preferredSize => Size.fromHeight(
    children.fold<double>(
      0,
      (totalHeight, child) => totalHeight + child.preferredSize.height,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Column(children: children);
  }
}

class _ServerStatusBanner extends StatelessWidget
    implements PreferredSizeWidget {
  const _ServerStatusBanner();

  static const _height = 60.0;

  @override
  Size get preferredSize => const Size.fromHeight(_height);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: double.infinity,
      color: colors.danger,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Text(
        _serverUnavailableBannerText,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onError,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

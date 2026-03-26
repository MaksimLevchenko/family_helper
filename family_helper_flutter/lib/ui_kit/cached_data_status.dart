import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/network/server_availability_cubit.dart';
import '../core/theme/app_colors.dart';

class CachedDataStatus extends StatelessWidget {
  const CachedDataStatus({
    super.key,
    required this.isUsingCachedData,
    required this.lastSuccessfulSyncAt,
  });

  final bool isUsingCachedData;
  final DateTime? lastSuccessfulSyncAt;

  @override
  Widget build(BuildContext context) {
    final isOffline =
        context.watch<ServerAvailabilityCubit?>()?.state.isUnavailable ?? false;

    if (!isOffline || !isUsingCachedData || lastSuccessfulSyncAt == null) {
      return const SizedBox.shrink();
    }

    final colors = context.colors;
    final savedAt = lastSuccessfulSyncAt!.toLocal();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colors.surfaceMuted,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.border),
        ),
        child: Text(
          'Last updated: ${_twoDigits(savedAt.day)}.${_twoDigits(savedAt.month)}.${savedAt.year} ${_twoDigits(savedAt.hour)}:${_twoDigits(savedAt.minute)}',
          style: TextStyle(
            color: colors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  String _twoDigits(int value) => value.toString().padLeft(2, '0');
}

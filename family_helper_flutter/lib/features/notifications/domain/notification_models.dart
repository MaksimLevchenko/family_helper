import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

enum NotificationPermissionStatus {
  notDetermined,
  granted,
  denied,
  permanentlyDenied,
}

extension NotificationPermissionStatusX on NotificationPermissionStatus {
  bool get isGranted => this == NotificationPermissionStatus.granted;

  String summaryLabel(AppLocalizations l10n) {
    return switch (this) {
      NotificationPermissionStatus.notDetermined =>
        l10n.notificationPermissionNotSetUp,
      NotificationPermissionStatus.granted => l10n.notificationPermissionAllowed,
      NotificationPermissionStatus.denied => l10n.notificationPermissionBlocked,
      NotificationPermissionStatus.permanentlyDenied =>
        l10n.notificationPermissionBlockedInSettings,
    };
  }

  String actionLabel(AppLocalizations l10n) {
    return switch (this) {
      NotificationPermissionStatus.notDetermined =>
        l10n.notificationPermissionAllowAction,
      NotificationPermissionStatus.granted =>
        l10n.notificationPermissionEnabledAction,
      NotificationPermissionStatus.denied =>
        l10n.notificationPermissionOpenSettingsAction,
      NotificationPermissionStatus.permanentlyDenied =>
        l10n.notificationPermissionOpenSettingsAction,
    };
  }

  String description(AppLocalizations l10n) {
    return switch (this) {
      NotificationPermissionStatus.notDetermined =>
        l10n.notificationPermissionNotSetUpDescription,
      NotificationPermissionStatus.granted =>
        l10n.notificationPermissionAllowedDescription,
      NotificationPermissionStatus.denied =>
        l10n.notificationPermissionBlockedDescription,
      NotificationPermissionStatus.permanentlyDenied =>
        l10n.notificationPermissionBlockedInSettingsDescription,
    };
  }
}

enum ReminderPreset {
  none,
  atTime,
  tenMinutesBefore,
  oneHourBefore,
  oneDayBefore,
}

extension ReminderPresetX on ReminderPreset {
  String label(AppLocalizations l10n) {
    return switch (this) {
      ReminderPreset.none => l10n.notificationPresetNone,
      ReminderPreset.atTime => l10n.notificationPresetAtTime,
      ReminderPreset.tenMinutesBefore => l10n.notificationPresetTenMinutesBefore,
      ReminderPreset.oneHourBefore => l10n.notificationPresetOneHourBefore,
      ReminderPreset.oneDayBefore => l10n.notificationPresetOneDayBefore,
    };
  }

  Duration? get offset {
    return switch (this) {
      ReminderPreset.none => null,
      ReminderPreset.atTime => Duration.zero,
      ReminderPreset.tenMinutesBefore => const Duration(minutes: 10),
      ReminderPreset.oneHourBefore => const Duration(hours: 1),
      ReminderPreset.oneDayBefore => const Duration(days: 1),
    };
  }

  DateTime? scheduleAt(DateTime baseTime) {
    final value = offset;
    if (value == null) {
      return null;
    }
    return baseTime.subtract(value);
  }
}

class ReminderActionResult {
  const ReminderActionResult({
    required this.success,
    this.message,
  });

  final bool success;
  final String? message;

  static const successResult = ReminderActionResult(success: true);

  factory ReminderActionResult.failure(String message) {
    return ReminderActionResult(success: false, message: message);
  }
}

class ReminderPresetField extends StatelessWidget {
  const ReminderPresetField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  final String label;
  final ReminderPreset value;
  final ValueChanged<ReminderPreset?> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return DropdownButtonFormField<ReminderPreset>(
      initialValue: value,
      decoration: InputDecoration(labelText: label),
      items: ReminderPreset.values
          .map(
            (preset) => DropdownMenuItem<ReminderPreset>(
              value: preset,
              child: Text(preset.label(l10n)),
            ),
          )
          .toList(),
      onChanged: enabled ? onChanged : null,
    );
  }
}

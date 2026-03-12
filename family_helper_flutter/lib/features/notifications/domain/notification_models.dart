import 'package:flutter/material.dart';

enum NotificationPermissionStatus {
  notDetermined,
  granted,
  denied,
  permanentlyDenied,
}

extension NotificationPermissionStatusX on NotificationPermissionStatus {
  bool get isGranted => this == NotificationPermissionStatus.granted;

  String get summaryLabel {
    return switch (this) {
      NotificationPermissionStatus.notDetermined => 'Not set up',
      NotificationPermissionStatus.granted => 'Allowed',
      NotificationPermissionStatus.denied => 'Blocked',
      NotificationPermissionStatus.permanentlyDenied => 'Blocked in settings',
    };
  }

  String get actionLabel {
    return switch (this) {
      NotificationPermissionStatus.notDetermined => 'Allow notifications',
      NotificationPermissionStatus.granted => 'Notifications enabled',
      NotificationPermissionStatus.denied => 'Open system settings',
      NotificationPermissionStatus.permanentlyDenied =>
        'Open system settings',
    };
  }

  String get description {
    return switch (this) {
      NotificationPermissionStatus.notDetermined =>
        'Turn on notifications so Family Helper can remind you about tasks and events.',
      NotificationPermissionStatus.granted =>
        'Notifications are enabled for this device.',
      NotificationPermissionStatus.denied =>
        'Notifications were denied. Open system settings to allow them.',
      NotificationPermissionStatus.permanentlyDenied =>
        'Notifications are disabled in system settings. Re-enable them there to get reminders.',
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
  String get label {
    return switch (this) {
      ReminderPreset.none => 'No reminder',
      ReminderPreset.atTime => 'At time',
      ReminderPreset.tenMinutesBefore => '10 minutes before',
      ReminderPreset.oneHourBefore => '1 hour before',
      ReminderPreset.oneDayBefore => '1 day before',
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
    return DropdownButtonFormField<ReminderPreset>(
      initialValue: value,
      decoration: InputDecoration(labelText: label),
      items: ReminderPreset.values
          .map(
            (preset) => DropdownMenuItem<ReminderPreset>(
              value: preset,
              child: Text(preset.label),
            ),
          )
          .toList(),
      onChanged: enabled ? onChanged : null,
    );
  }
}

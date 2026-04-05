import 'package:flutter/widgets.dart';

import 'l10n.dart';

String localizeUiError(BuildContext context, String? error) {
  if (error == null || error.isEmpty) {
    return '';
  }

  final l10n = context.l10n;
  return switch (error) {
    'Family is not selected' => l10n.uiErrorFamilyNotSelected,
    'Family/task is not selected' => l10n.uiErrorFamilyTaskNotSelected,
    'Family/goal is not selected' => l10n.uiErrorFamilyGoalNotSelected,
    'Archived goals cannot be edited' =>
      l10n.uiErrorArchivedGoalCannotBeEdited,
    'Family name cannot be empty' => l10n.uiErrorFamilyNameEmpty,
    'Network unavailable. Family rename queued.' =>
      l10n.uiErrorFamilyRenameQueued,
    'Network unavailable. Transfer request queued.' =>
      l10n.uiErrorFamilyTransferQueued,
    'Network unavailable. Leave request queued.' =>
      l10n.uiErrorFamilyLeaveQueued,
    'Network unavailable. Export request queued.' =>
      l10n.uiErrorPrivacyExportQueued,
    'Network unavailable. Deletion request queued.' =>
      l10n.uiErrorPrivacyDeletionQueued,
    'Network unavailable. Delete request queued.' =>
      l10n.uiErrorMediaDeleteQueued,
    'Export is still processing. Check back in a moment.' =>
      l10n.uiErrorExportProcessing,
    _ => error,
  };
}

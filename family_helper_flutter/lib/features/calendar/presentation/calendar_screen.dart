import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/l10n/ui_error_localizer.dart';
import '../../../core/network/server_availability_cubit.dart';
import '../../../core/theme/app_colors.dart';
import '../../../ui_kit/ui_kit.dart';
import '../../notifications/domain/notification_models.dart';
import '../domain/calendar_event_form.dart';
import '../providers/calendar_provider.dart';

part 'calendar_screen_forms.dart';
part 'calendar_screen_sections.dart';

const double _calendarWideLayoutBreakpoint = 720;
const double _calendarMaxWidthBreakpoint = 1100;
const double _calendarMaxContentWidth = 1280;
const double _calendarMonthPaneWidth = 440;

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isOffline =
        context.watch<ServerAvailabilityCubit?>()?.state.isUnavailable ?? false;

    return Scaffold(
      appBar: serverStatusAppBar(
        context,
        title: Text(context.l10n.homeCalendar),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: isOffline ? null : () => _openCreateEvent(context),
        icon: const Icon(Icons.add_circle_outline_rounded),
        label: Text(context.l10n.calendarAddEvent),
      ),
      body: BlocConsumer<CalendarCubit, CalendarState>(
        listenWhen: (previous, current) =>
            previous.error != current.error &&
            current.error != null &&
            current.errorFromMutation,
        listener: (context, state) {
          final messenger = ScaffoldMessenger.of(context);
          messenger
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(localizeUiError(context, state.error))),
            );
        },
        builder: (context, state) {
          if (state.isInitialLoading && state.instances.isEmpty) {
            return LoadingState(label: context.l10n.calendarLoading);
          }

          if (state.error != null &&
              !state.errorFromMutation &&
              state.instances.isEmpty) {
            return ErrorState(
              message: localizeUiError(context, state.error),
              onRetry: () => context.read<CalendarCubit>().reload(),
            );
          }

          return _CalendarScreenContent(
            state: state,
            isOffline: isOffline,
            onCreateEvent: () => _openCreateEvent(context),
            onOpenInstanceActions: (instance) =>
                _openInstanceActions(context, instance),
          );
        },
      ),
    );
  }

  Future<void> _openCreateEvent(BuildContext context) async {
    final isOffline =
        context.read<ServerAvailabilityCubit?>()?.state.isUnavailable ?? false;
    if (isOffline) {
      _showOfflineMessage(context);
      return;
    }
    final cubit = context.read<CalendarCubit>();
    final initialForm = CalendarEventForm.createDefault(
      context.read<CalendarCubit>().state.selectedDay,
    );
    final form = await _showAdaptiveOverlay<CalendarEventForm>(
      context,
      maxWidth: 720,
      builder: (overlayContext, useModalShell) => _CalendarEventEditorSheet(
        title: context.l10n.calendarCreateEventTitle,
        submitLabel: context.l10n.calendarSaveEvent,
        initialForm: initialForm,
        allowRecurrence: true,
        useModalShell: useModalShell,
      ),
    );
    if (form == null || !context.mounted) {
      return;
    }
    await cubit.saveSeries(form: form);
  }

  Future<void> _openInstanceActions(
    BuildContext context,
    CalendarInstanceDto instance,
  ) async {
    final isOffline =
        context.read<ServerAvailabilityCubit?>()?.state.isUnavailable ?? false;
    if (isOffline) {
      _showOfflineMessage(context);
      return;
    }
    final action = await _showAdaptiveOverlay<_CalendarAction>(
      context,
      maxWidth: 560,
      builder: (overlayContext, useModalShell) => _CalendarActionSheet(
        instance: instance,
        useModalShell: useModalShell,
      ),
    );
    if (action == null || !context.mounted) {
      return;
    }

    switch (action) {
      case _CalendarAction.editOne:
        await _editOccurrence(context, instance);
        return;
      case _CalendarAction.editFuture:
        await _editSeries(
          context,
          instance,
          scope: CalendarMutationScope.future,
        );
        return;
      case _CalendarAction.editAll:
        await _editSeries(
          context,
          instance,
          scope: CalendarMutationScope.all,
        );
        return;
      case _CalendarAction.deleteOne:
        await _confirmDeleteOccurrence(context, instance);
        return;
      case _CalendarAction.deleteFuture:
        await _confirmDeleteSeries(
          context,
          instance,
          scope: CalendarMutationScope.future,
        );
        return;
      case _CalendarAction.deleteAll:
        await _confirmDeleteSeries(
          context,
          instance,
          scope: CalendarMutationScope.all,
        );
        return;
    }
  }

  Future<void> _editOccurrence(
    BuildContext context,
    CalendarInstanceDto instance,
  ) async {
    final isOffline =
        context.read<ServerAvailabilityCubit?>()?.state.isUnavailable ?? false;
    if (isOffline) {
      _showOfflineMessage(context);
      return;
    }
    final cubit = context.read<CalendarCubit>();
    final form = await _showAdaptiveOverlay<CalendarEventForm>(
      context,
      maxWidth: 720,
      builder: (overlayContext, useModalShell) => _CalendarEventEditorSheet(
        title: context.l10n.calendarEditOccurrenceTitle,
        submitLabel: context.l10n.commonSaveChanges,
        initialForm: CalendarEventForm.fromInstance(instance),
        allowRecurrence: false,
        useModalShell: useModalShell,
      ),
    );
    if (form == null || !context.mounted) {
      return;
    }
    await cubit.saveOccurrence(instance: instance, form: form);
  }

  Future<void> _editSeries(
    BuildContext context,
    CalendarInstanceDto instance, {
    required CalendarMutationScope scope,
  }) async {
    final isOffline =
        context.read<ServerAvailabilityCubit?>()?.state.isUnavailable ?? false;
    if (isOffline) {
      _showOfflineMessage(context);
      return;
    }
    final cubit = context.read<CalendarCubit>();
    final event = await cubit.loadEvent(instance.eventId);
    if (!context.mounted) {
      return;
    }

    final initialForm = scope == CalendarMutationScope.future
        ? CalendarEventForm(
            title: event.title,
            description: event.description,
            startsAt: instance.occurrenceStart,
            endsAt: instance.occurrenceEnd,
            recurrence: CalendarRecurrence.fromRrule(
              event.rrule,
              event.startsAt,
            ),
            reminderPreset: CalendarEventForm.fromEvent(event).reminderPreset,
          )
        : CalendarEventForm.fromEvent(event);
    final title = scope == CalendarMutationScope.future
        ? context.l10n.calendarEditFollowingTitle
        : context.l10n.calendarEditWholeSeriesTitle;
    final form = await _showAdaptiveOverlay<CalendarEventForm>(
      context,
      maxWidth: 720,
      builder: (overlayContext, useModalShell) => _CalendarEventEditorSheet(
        title: title,
        submitLabel: context.l10n.commonSaveChanges,
        initialForm: initialForm,
        allowRecurrence: true,
        useModalShell: useModalShell,
      ),
    );
    if (form == null || !context.mounted) {
      return;
    }
    await cubit.saveSeries(
      form: form,
      eventId: event.id,
      scope: scope,
      anchorOccurrenceStart: scope == CalendarMutationScope.future
          ? instance.occurrenceKeyStart
          : null,
    );
  }

  Future<void> _confirmDeleteOccurrence(
    BuildContext context,
    CalendarInstanceDto instance,
  ) async {
    final isOffline =
        context.read<ServerAvailabilityCubit?>()?.state.isUnavailable ?? false;
    if (isOffline) {
      _showOfflineMessage(context);
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AppDialog(
          title: context.l10n.calendarDeleteOccurrenceTitle,
          message: context.l10n.calendarDeleteOccurrenceMessage,
          confirmLabel: context.l10n.commonDelete,
          onConfirm: () => Navigator.of(dialogContext).pop(true),
        );
      },
    );
    if (confirmed != true || !context.mounted) {
      return;
    }
    await context.read<CalendarCubit>().deleteOccurrence(instance);
  }

  Future<void> _confirmDeleteSeries(
    BuildContext context,
    CalendarInstanceDto instance, {
    required CalendarMutationScope scope,
  }) async {
    final isOffline =
        context.read<ServerAvailabilityCubit?>()?.state.isUnavailable ?? false;
    if (isOffline) {
      _showOfflineMessage(context);
      return;
    }
    final message = scope == CalendarMutationScope.future
        ? context.l10n.calendarDeleteSeriesFutureMessage
        : context.l10n.calendarDeleteSeriesAllMessage;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AppDialog(
          title: context.l10n.calendarDeleteEventTitle,
          message: message,
          confirmLabel: context.l10n.commonDelete,
          onConfirm: () => Navigator.of(dialogContext).pop(true),
        );
      },
    );
    if (confirmed != true || !context.mounted) {
      return;
    }
    await context.read<CalendarCubit>().deleteSeries(
      instance: instance,
      scope: scope,
    );
  }

  Future<T?> _showAdaptiveOverlay<T>(
    BuildContext context, {
    required Widget Function(BuildContext context, bool useModalShell) builder,
    required double maxWidth,
  }) {
    final isWide =
        MediaQuery.sizeOf(context).width >= _calendarWideLayoutBreakpoint;
    if (isWide) {
      return showDialog<T>(
        context: context,
        builder: (dialogContext) {
          return Dialog(
            insetPadding: const EdgeInsets.all(24),
            clipBehavior: Clip.antiAlias,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: maxWidth,
                maxHeight: MediaQuery.sizeOf(dialogContext).height * 0.9,
              ),
              child: builder(dialogContext, false),
            ),
          );
        },
      );
    }

    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => builder(sheetContext, true),
    );
  }
}

List<Widget> _withGaps(List<Widget> widgets, {required double gap}) {
  final spaced = <Widget>[];
  for (var index = 0; index < widgets.length; index++) {
    if (index > 0) {
      spaced.add(SizedBox(height: gap));
    }
    spaced.add(widgets[index]);
  }
  return spaced;
}

void _showOfflineMessage(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(context.l10n.calendarOfflineMessage),
    ),
  );
}

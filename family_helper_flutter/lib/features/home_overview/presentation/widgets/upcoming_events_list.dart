import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/routing/app_routes.dart';
import 'home_overview_support_widgets.dart';
import 'info_row_card.dart';

class UpcomingEventsList extends StatelessWidget {
  const UpcomingEventsList({super.key, required this.events});

  final List<CalendarInstanceDto> events;

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return HomeOverviewSectionEmptyState(
        title: context.l10n.homeNoUpcomingEventsTitle,
        message: context.l10n.homeNoUpcomingEventsMessage,
      );
    }

    return Column(
      children: events
          .map(
            (event) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: HomeInfoRowCard(
                title: event.title,
                subtitle: homeOverviewEventTimeLabel(event),
                icon: Icons.event_available_rounded,
                onTap: () => context.go(AppRoutes.calendar),
              ),
            ),
          )
          .toList(growable: false),
    );
  }
}

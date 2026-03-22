import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:calorhythm/presentation/extensions/datetime_extension.dart';
import 'package:calorhythm/domain/entities/workout_session.dart';
import 'package:calorhythm/presentation/router/app_router.dart';
import 'package:calorhythm/presentation/features/history/providers/history_provider.dart';
import 'package:calorhythm/presentation/features/history/widgets/info_row.dart';
import 'package:calorhythm/presentation/features/history/widgets/session_status_badge.dart';

class SessionListItem extends ConsumerWidget {
  const SessionListItem({super.key, required this.session});

  final WorkoutSession session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final caloriesAsync = ref.watch(sessionTotalCaloriesProvider(session.id));

    final timeRange = session.endTime != null
        ? '${session.startTime.timeLabel} - ${session.endTime!.timeLabel}'
        : session.startTime.timeLabel;

    final caloriesLabel = caloriesAsync.whenOrNull(
          data: (cal) => '${cal.toStringAsFixed(1)} kcal',
        ) ??
        '— kcal';

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          if (session.isInProgress) {
            context.go(AppRoutes.workout);
          } else {
            context.go(
              '${AppRoutes.history}/${session.id}',
              extra: session,
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SessionStatusBadge(status: session.status),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    InfoRow(
                      icon: Icons.calendar_today_outlined,
                      label: session.startTime.dateLabel,
                    ),
                    InfoRow(
                      icon: Icons.access_time_outlined,
                      label: timeRange,
                    ),
                    InfoRow(
                      icon: Icons.local_fire_department_outlined,
                      label: caloriesLabel,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

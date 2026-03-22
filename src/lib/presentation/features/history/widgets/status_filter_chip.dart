import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:calorhythm/application/dtos/workout_history_filter.dart';
import 'package:calorhythm/domain/entities/workout_session.dart';
import 'package:calorhythm/presentation/features/history/providers/history_provider.dart';
import 'package:calorhythm/presentation/features/history/widgets/status_picker_sheet.dart';

class StatusFilterChip extends ConsumerWidget {
  const StatusFilterChip({super.key, required this.filter});

  final WorkoutHistoryFilter filter;

  String _label() {
    if (!filter.isStatusActive) return 'Status';

    final ordered = [
      SessionStatus.completed,
      SessionStatus.inProgress,
      SessionStatus.abandoned,
    ].where(filter.statuses.contains).toList();

    final first = _statusLabel(ordered.first);
    if (ordered.length == 1) return first;
    return '$first +${ordered.length - 1}';
  }

  static String _statusLabel(SessionStatus s) => switch (s) {
        SessionStatus.completed => 'Completed',
        SessionStatus.inProgress => 'In progress',
        SessionStatus.abandoned => 'Abandoned',
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isActive = filter.isStatusActive;

    return InputChip(
      label: Text(_label()),
      avatar: Icon(
        isActive ? Icons.check_circle : Icons.tune,
        size: 16,
      ),
      deleteIcon: isActive ? const Icon(Icons.close, size: 14) : null,
      onDeleted: isActive
          ? () {
              final current = ref
                      .read(workoutHistoryNotifierProvider)
                      .valueOrNull
                      ?.filter ??
                  const WorkoutHistoryFilter();
              ref
                  .read(workoutHistoryNotifierProvider.notifier)
                  .applyFilter(current.clearStatuses());
            }
          : null,
      backgroundColor: isActive
          ? Theme.of(context).colorScheme.primaryContainer
          : null,
      labelStyle: TextStyle(
        color: isActive
            ? Theme.of(context).colorScheme.onPrimaryContainer
            : null,
        fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
      ),
      onPressed: () => _showStatusPicker(context, ref),
    );
  }

  Future<void> _showStatusPicker(BuildContext context, WidgetRef ref) async {
    final current = ref
            .read(workoutHistoryNotifierProvider)
            .valueOrNull
            ?.filter ??
        const WorkoutHistoryFilter();
    final selected = Set<SessionStatus>.from(current.statuses);

    final result = await showModalBottomSheet<Set<SessionStatus>>(
      context: context,
      builder: (ctx) => StatusPickerSheet(initial: selected),
    );

    if (result != null) {
      ref
          .read(workoutHistoryNotifierProvider.notifier)
          .applyFilter(current.copyWith(statuses: result));
    }
  }
}

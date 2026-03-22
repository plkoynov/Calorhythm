import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:calorhythm/application/dtos/workout_history_filter.dart';
import 'package:calorhythm/presentation/features/history/providers/history_provider.dart';

const _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

String _fmtDate(DateTime d) =>
    '${d.day.toString().padLeft(2, '0')} ${_months[d.month - 1]} ${d.year}';

class DateFilterChip extends ConsumerWidget {
  const DateFilterChip({super.key, required this.filter});

  final WorkoutHistoryFilter filter;

  String _label() {
    final start = filter.startDate;
    final end = filter.endDate;
    if (start == null && end == null) return 'Date';
    if (start != null && end != null) {
      return '${_fmtDate(start)} – ${_fmtDate(end)}';
    }
    if (start != null) return 'From ${_fmtDate(start)}';
    return 'Until ${_fmtDate(end!)}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isActive = filter.isDateActive;

    return InputChip(
      label: Text(_label()),
      avatar: Icon(
        isActive ? Icons.event : Icons.calendar_today_outlined,
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
                  .applyFilter(current.clearDate());
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
      onPressed: () => _showDatePicker(context, ref),
    );
  }

  Future<void> _showDatePicker(BuildContext context, WidgetRef ref) async {
    final current = ref
            .read(workoutHistoryNotifierProvider)
            .valueOrNull
            ?.filter ??
        const WorkoutHistoryFilter();

    final now = DateTime.now();
    final result = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: now,
      initialDateRange: current.startDate != null && current.endDate != null
          ? DateTimeRange(start: current.startDate!, end: current.endDate!)
          : null,
    );

    if (result != null) {
      ref.read(workoutHistoryNotifierProvider.notifier).applyFilter(
            current.copyWith(
              startDate: result.start,
              endDate: result.end,
            ),
          );
    }
  }
}

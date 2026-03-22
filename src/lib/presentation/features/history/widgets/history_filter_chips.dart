import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:calorhythm/application/dtos/workout_history_filter.dart';
import 'package:calorhythm/presentation/features/history/providers/history_provider.dart';
import 'package:calorhythm/presentation/features/history/widgets/date_filter_chip.dart';
import 'package:calorhythm/presentation/features/history/widgets/status_filter_chip.dart';

class HistoryFilterChips extends ConsumerWidget {
  const HistoryFilterChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(workoutHistoryNotifierProvider);
    final filter =
        historyAsync.valueOrNull?.filter ?? const WorkoutHistoryFilter();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: [
          StatusFilterChip(filter: filter),
          const SizedBox(width: 8),
          DateFilterChip(filter: filter),
        ],
      ),
    );
  }
}

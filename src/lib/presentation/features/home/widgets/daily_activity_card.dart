import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:calorhythm/presentation/features/home/providers/home_provider.dart';
import 'package:calorhythm/presentation/features/home/widgets/activity_metric.dart';
import 'package:calorhythm/presentation/features/home/widgets/concentric_section.dart';

class DailyActivityCard extends ConsumerWidget {
  const DailyActivityCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pieAsync = ref.watch(todayPieChartProvider);
    final statsAsync = ref.watch(todayStatsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        pieAsync.when(
          loading: () => const SizedBox(
              height: 180, child: Center(child: CircularProgressIndicator())),
          error: (e, _) => Text('Error: $e'),
          data: (entries) => entries.isEmpty
              ? const SizedBox(
                  height: 100,
                  child: Center(child: Text('No exercises today')),
                )
              : ConcentricSection(entries: entries),
        ),
        const SizedBox(height: 16),
        statsAsync.when(
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
          data: (stats) {
            final totalSeconds = pieAsync.valueOrNull
                    ?.fold<int>(0, (s, e) => s + e.totalDurationSeconds) ??
                0;
            final mins = totalSeconds ~/ 60;
            final secs = totalSeconds % 60;
            final timeLabel = mins > 0 ? '${mins}m ${secs}s' : '${secs}s';

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ActivityMetric(
                  icon: Icons.local_fire_department,
                  color: Colors.orange,
                  value: '${_formatCal(stats.totalCalories)} kcal',
                  label: 'Calories',
                ),
                ActivityMetric(
                  icon: Icons.timer_outlined,
                  color: Colors.teal,
                  value: timeLabel,
                  label: 'Total time',
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

String _formatCal(double v) =>
    v == v.truncateToDouble() ? v.toInt().toString() : v.toStringAsFixed(1);

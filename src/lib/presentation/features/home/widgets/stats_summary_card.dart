import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:calorhythm/presentation/constants/app_strings.dart';
import 'package:calorhythm/application/usecases/session/get_statistics.dart';
import 'package:calorhythm/presentation/features/home/widgets/stats_metric.dart';

class StatsSummaryCard extends StatelessWidget {
  const StatsSummaryCard({
    super.key,
    required this.label,
    required this.statsAsync,
  });

  final String label;
  final AsyncValue<WorkoutStatistics> statsAsync;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            statsAsync.when(
              data: (stats) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  StatsMetric(
                    value: stats.totalCalories.toStringAsFixed(0),
                    label: AppStrings.calories,
                  ),
                  StatsMetric(
                    value: stats.sessionCount.toString(),
                    label: AppStrings.sessions,
                  ),
                ],
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('Error: $e'),
            ),
          ],
        ),
      ),
    );
  }
}

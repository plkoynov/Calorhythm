import 'package:flutter/material.dart';

import 'package:calorhythm/presentation/extensions/datetime_extension.dart';
import 'package:calorhythm/domain/entities/exercise_entry.dart';

class ExerciseEntryTile extends StatelessWidget {
  const ExerciseEntryTile({super.key, required this.entry});

  final ExerciseEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final durationLabel = entry.totalDurationSeconds.asTimerLabel;
    final calories = entry.caloriesBurned.toStringAsFixed(1);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 20,
            child: Icon(Icons.fitness_center, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.exerciseName,
                  style: theme.textTheme.titleSmall,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.timer_outlined, size: 14),
                    const SizedBox(width: 4),
                    Text(durationLabel, style: theme.textTheme.bodySmall),
                    if (entry.totalRepetitions != null) ...[
                      const SizedBox(width: 12),
                      const Icon(Icons.repeat, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        '${entry.totalRepetitions} reps',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Text(
            '$calories kcal',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

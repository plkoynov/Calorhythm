import 'package:flutter/material.dart';

import 'package:calorhythm/domain/entities/exercise_entry.dart';
import 'package:calorhythm/presentation/features/exercises/widgets/exercise_stats_row.dart';

class SessionExerciseTile extends StatelessWidget {
  const SessionExerciseTile({
    super.key,
    required this.entry,
    required this.onTap,
  });

  final ExerciseEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Icon(
                  Icons.fitness_center,
                  color: theme.colorScheme.onPrimaryContainer,
                  size: 20,
                ),
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
                    const SizedBox(height: 4),
                    ExerciseStatsRow(entry: entry),
                  ],
                ),
              ),
              Icon(
                Icons.play_circle_outline,
                color: theme.colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'package:calorhythm/domain/entities/exercise_entry.dart';
import 'package:calorhythm/presentation/extensions/datetime_extension.dart';

class ExerciseStatsRow extends StatelessWidget {
  const ExerciseStatsRow({super.key, required this.entry});

  final ExerciseEntry entry;

  @override
  Widget build(BuildContext context) {
    final items = [
      _statLabel(Icons.timer_outlined, entry.totalDurationSeconds.asTimerLabel),
      if (entry.totalRepetitions != null)
        _statLabel(Icons.repeat, '${entry.totalRepetitions} reps'),
      _statLabel(Icons.local_fire_department_outlined,
          '${entry.caloriesBurned.toStringAsFixed(1)} kcal'),
    ];

    return Row(
      children: items.expand((w) => [w, const SizedBox(width: 12)]).toList()
        ..removeLast(),
    );
  }

  Widget _statLabel(IconData icon, String label) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.grey),
          const SizedBox(width: 2),
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      );
}

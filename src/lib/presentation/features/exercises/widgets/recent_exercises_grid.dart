import 'package:flutter/material.dart';

import 'package:calorhythm/domain/entities/exercise.dart';
import 'package:calorhythm/presentation/features/exercises/widgets/exercise_tile.dart';

class RecentExercisesGrid extends StatelessWidget {
  const RecentExercisesGrid({
    super.key,
    required this.exercises,
    required this.onTap,
  });

  final List<Exercise> exercises;
  final void Function(Exercise) onTap;

  @override
  Widget build(BuildContext context) => GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.1,
        ),
        itemCount: exercises.length,
        itemBuilder: (context, index) => ExerciseTile(
          exercise: exercises[index],
          onTap: () => onTap(exercises[index]),
        ),
      );
}

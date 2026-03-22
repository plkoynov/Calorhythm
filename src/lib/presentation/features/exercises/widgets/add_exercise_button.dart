import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:calorhythm/presentation/router/app_routes.dart';
import 'package:calorhythm/presentation/features/exercises/widgets/exercise_search_sheet.dart';

class AddExerciseButton extends StatelessWidget {
  const AddExerciseButton({super.key, required this.sessionId});

  final int sessionId;

  @override
  Widget build(BuildContext context) => IconButton.filled(
        icon: const Icon(Icons.add),
        tooltip: 'Find an exercise',
        onPressed: () async {
          final exercise = await ExerciseSearchSheet.show(context);
          if (exercise != null && context.mounted) {
            context.push(
              AppRoutes.exerciseTimer.replaceAll(':id', '${exercise.id}'),
            );
          }
        },
      );
}

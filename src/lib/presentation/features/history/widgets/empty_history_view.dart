import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:calorhythm/presentation/router/app_router.dart';
import 'package:calorhythm/presentation/features/exercises/providers/exercises_provider.dart';

class EmptyHistoryView extends ConsumerWidget {
  const EmptyHistoryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.history_rounded,
              size: 72,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
            ),
            const SizedBox(height: 20),
            Text(
              'No workouts yet',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your completed sessions will appear here. Finish your first workout and start writing your story.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 28),
            FilledButton.icon(
              onPressed: () async {
                await ref.read(sessionManagerProvider.notifier).startSession();
                if (context.mounted) context.go(AppRoutes.workout);
              },
              icon: const Icon(Icons.fitness_center_outlined, size: 18),
              label: const Text('Start Workout'),
            ),
          ],
        ),
      ),
    );
  }
}

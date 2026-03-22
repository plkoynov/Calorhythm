import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:calorhythm/domain/entities/workout_session.dart';
import 'package:calorhythm/presentation/constants/app_colors.dart';
import 'package:calorhythm/presentation/router/app_routes.dart';
import 'package:calorhythm/presentation/features/exercises/providers/exercises_provider.dart';
import 'package:calorhythm/presentation/features/exercises/widgets/section_header.dart';
import 'package:calorhythm/presentation/features/exercises/widgets/empty_session_message.dart';
import 'package:calorhythm/presentation/features/exercises/widgets/empty_recent_message.dart';
import 'package:calorhythm/presentation/features/exercises/widgets/add_exercise_button.dart';
import 'package:calorhythm/presentation/features/exercises/widgets/recent_exercises_grid.dart';
import 'package:calorhythm/presentation/features/exercises/widgets/session_exercise_tile.dart';
import 'package:calorhythm/presentation/features/exercises/widgets/session_timer_bar.dart';
import 'package:go_router/go_router.dart';

class ActiveSessionView extends ConsumerWidget {
  const ActiveSessionView({super.key, required this.session});

  final WorkoutSession session;

  int get sessionId => session.id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(sessionEntriesProvider);
    final recentAsync = ref.watch(recentExercisesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Workout')),
      body: Column(
        children: [
          SessionTimerBar(
            session: session,
            onFinish: () => _confirmFinish(context, ref),
            onAbandon: () => _confirmAbandon(context, ref),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const SectionHeader(title: 'This Session'),
                const SizedBox(height: 8),
                entriesAsync.when(
                  data: (entries) => entries.isEmpty
                      ? const EmptySessionMessage()
                      : Column(
                          children: entries
                              .map((e) => Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: SessionExerciseTile(
                                      entry: e,
                                      onTap: () => _navigateToTimer(context, e.exerciseId),
                                    ),
                                  ))
                              .toList(),
                        ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Text('Error: $e'),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    const SectionHeader(title: 'Recent Exercises'),
                    const Spacer(),
                    AddExerciseButton(sessionId: sessionId),
                  ],
                ),
                const SizedBox(height: 8),
                recentAsync.when(
                  data: (exercises) => exercises.isEmpty
                      ? EmptyRecentMessage(sessionId: sessionId)
                      : RecentExercisesGrid(
                          exercises: exercises,
                          onTap: (ex) => _navigateToTimer(context, ex.id),
                        ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Text('Error: $e'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToTimer(BuildContext context, int exerciseId) {
    context.push(
      AppRoutes.exerciseTimer.replaceAll(':id', '$exerciseId'),
    );
  }

  Future<void> _confirmAbandon(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Abandon workout?'),
        content: const Text(
            'Your progress will be saved but the session will be marked as abandoned.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: Theme.of(ctx).colorScheme.error),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Abandon'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(sessionManagerProvider.notifier).abandonSession(sessionId);
    }
  }

  Future<void> _confirmFinish(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Finish workout?'),
        content: const Text('This will end your current session and save all progress.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.secondary),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Finish'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(sessionManagerProvider.notifier).completeSession(sessionId);
    }
  }
}

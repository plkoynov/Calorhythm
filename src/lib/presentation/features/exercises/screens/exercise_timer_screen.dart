import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:calorhythm/di/app_providers.dart';
import 'package:calorhythm/presentation/features/exercises/providers/exercises_provider.dart';
import 'package:calorhythm/presentation/features/exercises/providers/timer_provider.dart';
import 'package:calorhythm/presentation/features/exercises/widgets/circular_timer.dart';
import 'package:calorhythm/presentation/features/exercises/widgets/rep_input_dialog.dart';
import 'package:calorhythm/presentation/features/exercises/widgets/timer_controls.dart';

class ExerciseTimerScreen extends ConsumerStatefulWidget {
  const ExerciseTimerScreen({super.key, required this.exerciseId});

  final int exerciseId;

  @override
  ConsumerState<ExerciseTimerScreen> createState() =>
      _ExerciseTimerScreenState();
}

class _ExerciseTimerScreenState extends ConsumerState<ExerciseTimerScreen> {
  double? _caloriesBurned;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(exerciseTimerProvider.notifier).reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    final exercisesAsync = ref.watch(exerciseSearchProvider(''));
    final timerState = ref.watch(exerciseTimerProvider);

    return exercisesAsync.when(
      data: (exercises) {
        final exercise = exercises.firstWhere((e) => e.id == widget.exerciseId);

        final isActive = timerState.status == TimerStatus.running ||
            timerState.status == TimerStatus.paused;

        return Scaffold(
          appBar: AppBar(
            title: Text(exercise.name),
            automaticallyImplyLeading: !isActive,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SizedBox.expand(
              child: Stack(
                children: [
                  Align(
                    alignment: const Alignment(0, -0.45),
                    child: CircularTimer(timerState: timerState),
                  ),
                  Positioned(
                    bottom: 32,
                    left: 0,
                    right: 0,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_caloriesBurned != null) ...[
                          Card(
                            margin: const EdgeInsets.symmetric(horizontal: 24),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.local_fire_department,
                                      color: Colors.orange),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${_caloriesBurned!.toStringAsFixed(1)} kcal',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                        TimerControls(
                          status: timerState.status,
                          saving: _saving,
                          onStart: () =>
                              ref.read(exerciseTimerProvider.notifier).start(),
                          onPause: () =>
                              ref.read(exerciseTimerProvider.notifier).pause(),
                          onResume: () =>
                              ref.read(exerciseTimerProvider.notifier).resume(),
                          onFinish: () => _onFinish(
                            exercise: exercise,
                            elapsedSeconds: timerState.elapsedSeconds,
                          ),
                          onAnotherSet: () {
                            ref.read(exerciseTimerProvider.notifier).reset();
                            setState(() => _caloriesBurned = null);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
    );
  }

  Future<void> _onFinish({
    required dynamic exercise,
    required int elapsedSeconds,
  }) async {
    ref.read(exerciseTimerProvider.notifier).stop();

    if (elapsedSeconds == 0) {
      if (mounted) Navigator.of(context).pop();
      return;
    }

    int? reps;
    if (exercise.supportsRepMultiplier) {
      if (!mounted) return;
      reps = await showDialog<int>(
        context: context,
        builder: (_) => const RepInputDialog(),
      );
    }

    if (!exercise.supportsRepMultiplier) {
      if (!mounted) return;
      _saveAndShowCalories(
          exercise: exercise, elapsedSeconds: elapsedSeconds, reps: null);
      return;
    }

    _saveAndShowCalories(
        exercise: exercise, elapsedSeconds: elapsedSeconds, reps: reps);
  }

  Future<void> _saveAndShowCalories({
    required dynamic exercise,
    required int elapsedSeconds,
    required int? reps,
  }) async {
    setState(() => _saving = true);

    final session = await ref.read(activeSessionProvider.future);
    final profile = await ref.read(profileRepositoryProvider).get();
    if (session == null || !mounted) {
      setState(() => _saving = false);
      return;
    }

    await ref.read(recordExerciseSetProvider).call(
          sessionId: session.id,
          exerciseId: exercise.id,
          addedDurationSeconds: elapsedSeconds,
          addedRepetitions: reps,
          useRepMultiplier: profile?.useRepMultiplierForCalories ?? false,
        );

    ref.invalidate(sessionEntriesProvider);
    ref.invalidate(recentExercisesProvider);

    final entries = await ref.read(sessionEntriesProvider.future);
    final updated =
        entries.where((e) => e.exerciseId == exercise.id).firstOrNull;

    if (mounted) {
      setState(() {
        _caloriesBurned = updated?.caloriesBurned;
        _saving = false;
      });
    }
  }
}

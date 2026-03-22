import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:calorhythm/di/app_providers.dart';
import 'package:calorhythm/domain/entities/exercise.dart';
import 'package:calorhythm/domain/entities/exercise_entry.dart';
import 'package:calorhythm/domain/entities/workout_session.dart';
import 'package:calorhythm/presentation/features/exercises/providers/session_clock_provider.dart';

part 'exercises_provider.g.dart';

// ---------------------------------------------------------------------------
// Active session
// ---------------------------------------------------------------------------

@riverpod
Future<WorkoutSession?> activeSession(Ref ref) =>
    ref.watch(getActiveSessionProvider).call();

// ---------------------------------------------------------------------------
// Session entries — exercises logged in the current session
// ---------------------------------------------------------------------------

@riverpod
Future<List<ExerciseEntry>> sessionEntries(Ref ref) async {
  final session = await ref.watch(activeSessionProvider.future);
  if (session == null) return [];
  return ref.watch(getSessionEntriesProvider).call(session.id);
}

// ---------------------------------------------------------------------------
// Recent exercises
// ---------------------------------------------------------------------------

@riverpod
Future<List<Exercise>> recentExercises(Ref ref) =>
    ref.watch(getRecentExercisesProvider).call();

// ---------------------------------------------------------------------------
// Exercise search (autocomplete)
// ---------------------------------------------------------------------------

@riverpod
Future<List<Exercise>> exerciseSearch(
  Ref ref,
  String query,
) =>
    ref.watch(searchExercisesProvider).call(query);

// ---------------------------------------------------------------------------
// Session lifecycle
// ---------------------------------------------------------------------------

@riverpod
class SessionManager extends _$SessionManager {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<void> startSession() async {
    final existing = await ref.read(activeSessionProvider.future);
    if (existing != null) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(startWorkoutSessionProvider).call(),
    );
    ref.invalidate(activeSessionProvider);
    ref.invalidate(sessionEntriesProvider);
  }

  Future<void> completeSession(int id) async {
    state = const AsyncLoading();
    await _invalidateClock();
    state = await AsyncValue.guard(
      () => ref.read(completeWorkoutSessionProvider).call(id),
    );
    _invalidateSession();
  }

  Future<void> abandonSession(int id) async {
    state = const AsyncLoading();
    await _invalidateClock();
    state = await AsyncValue.guard(
      () => ref.read(abandonWorkoutSessionProvider).call(id),
    );
    _invalidateSession();
  }

  Future<void> _invalidateClock() async {
    final session = await ref.read(activeSessionProvider.future);
    if (session != null) {
      ref.invalidate(sessionClockProvider(session.startTime));
    }
  }

  void _invalidateSession() {
    ref.invalidate(activeSessionProvider);
    ref.invalidate(sessionEntriesProvider);
  }
}


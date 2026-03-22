import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:calorhythm/di/app_providers.dart';
import 'package:calorhythm/domain/entities/exercise_entry.dart';
import 'package:calorhythm/domain/entities/workout_session.dart';

part 'history_provider.g.dart';

@riverpod
Future<List<WorkoutSession>> workoutHistory(WorkoutHistoryRef ref) =>
    ref.watch(getWorkoutHistoryProvider).call();

@riverpod
Future<List<ExerciseEntry>> sessionDetailEntries(
  SessionDetailEntriesRef ref,
  int sessionId,
) =>
    ref.watch(getSessionEntriesProvider).call(sessionId);

@riverpod
Future<void> deleteSession(DeleteSessionRef ref, int sessionId) async {
  await ref.read(deleteWorkoutSessionProvider).call(sessionId);
  ref.invalidate(workoutHistoryProvider);
}

@riverpod
Future<double> sessionTotalCalories(
  SessionTotalCaloriesRef ref,
  int sessionId,
) async {
  final entries = await ref.watch(sessionDetailEntriesProvider(sessionId).future);
  return entries.fold<double>(0.0, (sum, e) => sum + e.caloriesBurned);
}

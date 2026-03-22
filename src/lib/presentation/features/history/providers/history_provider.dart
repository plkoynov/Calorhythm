import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:calorhythm/di/app_providers.dart';
import 'package:calorhythm/domain/entities/exercise_entry.dart';
import 'package:calorhythm/domain/entities/workout_session.dart';

part 'history_provider.g.dart';

const _pageSize = 20;

class WorkoutHistoryState {
  const WorkoutHistoryState({
    required this.sessions,
    required this.hasMore,
    this.isLoadingMore = false,
  });

  final List<WorkoutSession> sessions;
  final bool hasMore;
  final bool isLoadingMore;

  WorkoutHistoryState copyWith({
    List<WorkoutSession>? sessions,
    bool? hasMore,
    bool? isLoadingMore,
  }) =>
      WorkoutHistoryState(
        sessions: sessions ?? this.sessions,
        hasMore: hasMore ?? this.hasMore,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      );
}

@riverpod
class WorkoutHistoryNotifier extends _$WorkoutHistoryNotifier {
  @override
  Future<WorkoutHistoryState> build() async {
    final sessions = await ref
        .watch(getWorkoutHistoryProvider)
        .call(limit: _pageSize, offset: 0);
    return WorkoutHistoryState(
      sessions: sessions,
      hasMore: sessions.length == _pageSize,
    );
  }

  Future<void> loadNextPage() async {
    final current = state.valueOrNull;
    if (current == null || current.isLoadingMore || !current.hasMore) return;

    state = AsyncData(current.copyWith(isLoadingMore: true));

    final next = await ref
        .read(getWorkoutHistoryProvider)
        .call(limit: _pageSize, offset: current.sessions.length);

    state = AsyncData(
      WorkoutHistoryState(
        sessions: [...current.sessions, ...next],
        hasMore: next.length == _pageSize,
      ),
    );
  }
}

@riverpod
Future<List<ExerciseEntry>> sessionDetailEntries(
  SessionDetailEntriesRef ref,
  int sessionId,
) =>
    ref.watch(getSessionEntriesProvider).call(sessionId);

@riverpod
Future<void> deleteSession(DeleteSessionRef ref, int sessionId) async {
  await ref.read(deleteWorkoutSessionProvider).call(sessionId);
  ref.invalidate(workoutHistoryNotifierProvider);
}

@riverpod
Future<double> sessionTotalCalories(
  SessionTotalCaloriesRef ref,
  int sessionId,
) async {
  final entries =
      await ref.watch(sessionDetailEntriesProvider(sessionId).future);
  return entries.fold<double>(0.0, (sum, e) => sum + e.caloriesBurned);
}

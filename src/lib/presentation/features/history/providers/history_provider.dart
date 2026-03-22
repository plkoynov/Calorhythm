import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:calorhythm/di/app_providers.dart';
import 'package:calorhythm/domain/entities/exercise_entry.dart';
import 'package:calorhythm/application/dtos/workout_history_filter.dart';
import 'package:calorhythm/domain/entities/workout_session.dart';

part 'history_provider.g.dart';

const _pageSize = 20;

class WorkoutHistoryState {
  const WorkoutHistoryState({
    required this.sessions,
    required this.hasMore,
    required this.filter,
    this.isLoadingMore = false,
  });

  final List<WorkoutSession> sessions;
  final bool hasMore;
  final bool isLoadingMore;
  final WorkoutHistoryFilter filter;

  WorkoutHistoryState copyWith({
    List<WorkoutSession>? sessions,
    bool? hasMore,
    bool? isLoadingMore,
    WorkoutHistoryFilter? filter,
  }) =>
      WorkoutHistoryState(
        sessions: sessions ?? this.sessions,
        hasMore: hasMore ?? this.hasMore,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
        filter: filter ?? this.filter,
      );
}

@riverpod
class WorkoutHistoryNotifier extends _$WorkoutHistoryNotifier {
  @override
  Future<WorkoutHistoryState> build() async {
    const filter = WorkoutHistoryFilter();
    final sessions = await ref
        .watch(getWorkoutHistoryProvider)
        .call(limit: _pageSize, offset: 0, filter: filter);
    return WorkoutHistoryState(
      sessions: sessions,
      hasMore: sessions.length == _pageSize,
      filter: filter,
    );
  }

  Future<void> loadNextPage() async {
    final current = state.valueOrNull;
    if (current == null || current.isLoadingMore || !current.hasMore) return;

    state = AsyncData(current.copyWith(isLoadingMore: true));

    final next = await ref.read(getWorkoutHistoryProvider).call(
          limit: _pageSize,
          offset: current.sessions.length,
          filter: current.filter,
        );

    state = AsyncData(
      WorkoutHistoryState(
        sessions: [...current.sessions, ...next],
        hasMore: next.length == _pageSize,
        filter: current.filter,
      ),
    );
  }

  Future<void> applyFilter(WorkoutHistoryFilter filter) async {
    final sessions = await ref
        .read(getWorkoutHistoryProvider)
        .call(limit: _pageSize, offset: 0, filter: filter);
    state = AsyncData(
      WorkoutHistoryState(
        sessions: sessions,
        hasMore: sessions.length == _pageSize,
        filter: filter,
      ),
    );
  }
}

@riverpod
Future<List<ExerciseEntry>> sessionDetailEntries(
  Ref ref,
  int sessionId,
) =>
    ref.watch(getSessionEntriesProvider).call(sessionId);

@riverpod
Future<void> deleteSession(Ref ref, int sessionId) async {
  await ref.read(deleteWorkoutSessionProvider).call(sessionId);
  ref.invalidate(workoutHistoryNotifierProvider);
}

@riverpod
Future<double> sessionTotalCalories(
  Ref ref,
  int sessionId,
) async {
  final entries =
      await ref.watch(sessionDetailEntriesProvider(sessionId).future);
  return entries.fold<double>(0.0, (sum, e) => sum + e.caloriesBurned);
}

import 'package:calorhythm/domain/entities/workout_session.dart';

abstract interface class WorkoutSessionRepository {
  Future<WorkoutSession?> getById(int id);

  /// Returns the single in-progress session, if one exists.
  /// Used on app start for crash recovery.
  Future<WorkoutSession?> getInProgress();

  /// Returns a page of sessions (any status) ordered by startTime descending.
  Future<List<WorkoutSession>> getPage(int limit, int offset);

  /// Returns a filtered page of sessions ordered by startTime descending.
  /// Passing an empty [statuses] set or null means no status filter.
  Future<List<WorkoutSession>> getPageFiltered(
    int limit,
    int offset, {
    Set<SessionStatus>? statuses,
    DateTime? from,
    DateTime? to,
  });

  /// Returns all completed sessions ordered by startTime descending.
  Future<List<WorkoutSession>> getCompleted();

  /// Returns completed sessions that started within [from]..[to].
  Future<List<WorkoutSession>> getCompletedInRange(DateTime from, DateTime to);

  /// Returns session count and total calories for [from]..[to] in a single query.
  Future<({int sessionCount, double totalCalories})> getStatsForRange(
    DateTime from,
    DateTime to,
  );

  /// Creates a new in-progress session and returns it.
  Future<WorkoutSession> start(double userWeightKg);

  /// Marks the session as completed and sets endTime to now.
  Future<void> complete(int id);

  /// Marks the session as abandoned and sets endTime to now.
  Future<void> abandon(int id);

  /// Permanently deletes a session and all its exercise entries.
  Future<void> delete(int id);
}

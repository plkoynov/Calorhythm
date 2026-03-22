import 'package:drift/drift.dart';

import 'package:calorhythm/domain/entities/workout_session.dart';
import 'package:calorhythm/infrastructure/persistence/datasources/local/app_database.dart';

part 'workout_session_dao.g.dart';

@DriftAccessor(tables: [WorkoutSessionTable, ExerciseEntryTable])
class WorkoutSessionDao extends DatabaseAccessor<AppDatabase>
    with _$WorkoutSessionDaoMixin {
  WorkoutSessionDao(super.db);

  Future<WorkoutSessionTableData?> getById(int id) =>
      (select(workoutSessionTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<WorkoutSessionTableData?> getInProgress() =>
      (select(workoutSessionTable)
            ..where((t) => t.status.equalsValue(SessionStatus.inProgress))
            ..limit(1))
          .getSingleOrNull();

  Future<List<WorkoutSessionTableData>> getPage(int limit, int offset) =>
      (select(workoutSessionTable)
            ..orderBy([(t) => OrderingTerm.desc(t.startTime)])
            ..limit(limit, offset: offset))
          .get();

  Future<List<WorkoutSessionTableData>> getCompleted() =>
      (select(workoutSessionTable)
            ..where((t) => t.status.equalsValue(SessionStatus.completed))
            ..orderBy([(t) => OrderingTerm.desc(t.startTime)]))
          .get();

  Future<List<WorkoutSessionTableData>> getCompletedInRange(
    DateTime from,
    DateTime to,
  ) =>
      (select(workoutSessionTable)
            ..where(
              (t) =>
                  t.status.equalsValue(SessionStatus.completed) &
                  t.startTime.isBetweenValues(from, to),
            ))
          .get();

  Future<int> insert(WorkoutSessionTableCompanion companion) =>
      into(workoutSessionTable).insert(companion);

  Future<void> updateStatus({
    required int id,
    required SessionStatus status,
    DateTime? endTime,
  }) =>
      (update(workoutSessionTable)..where((t) => t.id.equals(id))).write(
        WorkoutSessionTableCompanion(
          status: Value(status),
          endTime: Value(endTime),
        ),
      );

  Future<int> deleteById(int id) =>
      (delete(workoutSessionTable)..where((t) => t.id.equals(id))).go();

  /// Returns session count and total calories for completed sessions in [from]..[to]
  /// in a single JOIN query — no N+1.
  Future<({int sessionCount, double totalCalories})> getStatsForRange(
    DateTime from,
    DateTime to,
  ) async {
    final sessionCount = workoutSessionTable.id.count(distinct: true);
    final totalCalories = exerciseEntryTable.caloriesBurned.sum();

    final query = selectOnly(workoutSessionTable)
      ..addColumns([sessionCount, totalCalories])
      ..join([
        leftOuterJoin(
          exerciseEntryTable,
          exerciseEntryTable.sessionId.equalsExp(workoutSessionTable.id),
        ),
      ])
      ..where(
        workoutSessionTable.status.equalsValue(SessionStatus.completed) &
            workoutSessionTable.startTime.isBetweenValues(from, to),
      );

    final row = await query.getSingle();
    return (
      sessionCount: row.read(sessionCount) ?? 0,
      totalCalories: row.read(totalCalories) ?? 0.0,
    );
  }
}

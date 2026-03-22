import 'package:drift/drift.dart';

import 'package:calorhythm/domain/entities/workout_session.dart';
import 'package:calorhythm/infrastructure/persistence/datasources/local/app_database.dart';

part 'exercise_entry_dao.g.dart';

/// Result type for the JOIN query between ExerciseEntry and Exercise tables.
class ExerciseEntryWithName {
  const ExerciseEntryWithName({
    required this.entry,
    required this.exerciseName,
  });

  final ExerciseEntryTableData entry;
  final String exerciseName;
}

@DriftAccessor(tables: [ExerciseEntryTable, ExerciseTable, WorkoutSessionTable])
class ExerciseEntryDao extends DatabaseAccessor<AppDatabase>
    with _$ExerciseEntryDaoMixin {
  ExerciseEntryDao(super.db);

  /// Returns all entries for a session joined with exercise name.
  Future<List<ExerciseEntryWithName>> getForSession(int sessionId) {
    final query = select(exerciseEntryTable).join([
      innerJoin(
        exerciseTable,
        exerciseTable.id.equalsExp(exerciseEntryTable.exerciseId),
      ),
    ])
      ..where(exerciseEntryTable.sessionId.equals(sessionId));

    return query.map((row) {
      return ExerciseEntryWithName(
        entry: row.readTable(exerciseEntryTable),
        exerciseName: row.readTable(exerciseTable).name,
      );
    }).get();
  }

  /// Returns a single entry for (sessionId, exerciseId) joined with exercise name.
  Future<ExerciseEntryWithName?> getEntry(int sessionId, int exerciseId) {
    final query = select(exerciseEntryTable).join([
      innerJoin(
        exerciseTable,
        exerciseTable.id.equalsExp(exerciseEntryTable.exerciseId),
      ),
    ])
      ..where(
        exerciseEntryTable.sessionId.equals(sessionId) &
            exerciseEntryTable.exerciseId.equals(exerciseId),
      );

    return query
        .map((row) => ExerciseEntryWithName(
              entry: row.readTable(exerciseEntryTable),
              exerciseName: row.readTable(exerciseTable).name,
            ))
        .getSingleOrNull();
  }

  /// Replaces the full entry row. Because the DB has a unique constraint on
  /// (sessionId, exerciseId), this handles both insert and update.
  Future<void> upsert(ExerciseEntryTableCompanion companion) =>
      into(exerciseEntryTable).insertOnConflictUpdate(companion);

  /// Returns up to [limit] distinct exercises ordered by the most recent
  /// session in which they were used (completed sessions only).
  Future<List<ExerciseTableData>> getRecentExercises(int limit) {
    final lastUsed = workoutSessionTable.startTime.max();

    final query = selectOnly(exerciseEntryTable)
      ..addColumns([...exerciseTable.$columns, lastUsed])
      ..join([
        innerJoin(
          exerciseTable,
          exerciseTable.id.equalsExp(exerciseEntryTable.exerciseId),
        ),
        innerJoin(
          workoutSessionTable,
          workoutSessionTable.id.equalsExp(exerciseEntryTable.sessionId),
        ),
      ])
      ..where(workoutSessionTable.status.equalsValue(SessionStatus.completed))
      ..groupBy([exerciseEntryTable.exerciseId])
      ..orderBy([OrderingTerm.desc(lastUsed)])
      ..limit(limit);

    return query
        .map((row) => ExerciseTableData(
              id: row.read(exerciseTable.id)!,
              name: row.read(exerciseTable.name)!,
              metValue: row.read(exerciseTable.metValue)!,
              colorHex: row.read(exerciseTable.colorHex)!,
              iconName: row.read(exerciseTable.iconName)!,
              referenceRepsPerMinute:
                  row.read(exerciseTable.referenceRepsPerMinute),
            ))
        .get();
  }

  /// Returns exercise breakdown (name, color, total duration, total calories) for all
  /// completed sessions that started within [from]..[to].
  Future<
      List<
          ({
            String exerciseName,
            String colorHex,
            int totalSeconds,
            double totalCalories
          })>> getExerciseBreakdownForRange(DateTime from, DateTime to) {
    final totalDuration = exerciseEntryTable.totalDurationSeconds.sum();
    final totalCalories = exerciseEntryTable.caloriesBurned.sum();

    final query = selectOnly(exerciseEntryTable)
      ..addColumns([
        exerciseTable.name,
        exerciseTable.colorHex,
        totalDuration,
        totalCalories
      ])
      ..join([
        innerJoin(
          workoutSessionTable,
          workoutSessionTable.id.equalsExp(exerciseEntryTable.sessionId),
        ),
        innerJoin(
          exerciseTable,
          exerciseTable.id.equalsExp(exerciseEntryTable.exerciseId),
        ),
      ])
      ..where(
        workoutSessionTable.startTime.isBetweenValues(from, to) &
            workoutSessionTable.status.equalsValue(SessionStatus.completed),
      )
      ..groupBy([exerciseEntryTable.exerciseId]);

    return query
        .map((row) => (
              exerciseName: row.read(exerciseTable.name)!,
              colorHex: row.read(exerciseTable.colorHex)!,
              totalSeconds: row.read(totalDuration) ?? 0,
              totalCalories: row.read(totalCalories) ?? 0.0,
            ))
        .get();
  }

  Future<int> deleteForSession(int sessionId) =>
      (delete(exerciseEntryTable)..where((t) => t.sessionId.equals(sessionId)))
          .go();
}

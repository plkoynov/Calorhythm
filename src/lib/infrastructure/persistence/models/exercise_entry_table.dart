import 'package:drift/drift.dart';

import 'exercise_table.dart';
import 'workout_session_table.dart';

class ExerciseEntryTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get sessionId => integer().references(WorkoutSessionTable, #id)();
  IntColumn get exerciseId => integer().references(ExerciseTable, #id)();

  IntColumn get totalDurationSeconds => integer()();
  IntColumn get totalRepetitions => integer().nullable()();
  RealColumn get caloriesBurned => real()();

  /// Ensures at most one entry per exercise per session — the basis for
  /// the accumulate-on-set-end upsert logic.
  @override
  List<Set<Column>> get uniqueKeys => [
        {sessionId, exerciseId},
      ];
}

import 'package:drift/drift.dart';

import 'package:calorhythm/domain/entities/exercise.dart';
import 'package:calorhythm/domain/entities/exercise_entry.dart';
import 'package:calorhythm/domain/repositories/exercise_entry_repository.dart';
import 'package:calorhythm/domain/entities/exercise_breakdown_entry.dart';
import 'package:calorhythm/infrastructure/persistence/datasources/local/app_database.dart';
import 'package:calorhythm/infrastructure/persistence/datasources/local/daos/exercise_entry_dao.dart';

class ExerciseEntryRepositoryImpl implements ExerciseEntryRepository {
  const ExerciseEntryRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Future<List<ExerciseEntry>> getForSession(int sessionId) async {
    final rows = await _db.exerciseEntryDao.getForSession(sessionId);
    return rows.map(_toEntity).toList();
  }

  @override
  Future<ExerciseEntry?> getEntry(int sessionId, int exerciseId) async {
    final row = await _db.exerciseEntryDao.getEntry(sessionId, exerciseId);
    return row == null ? null : _toEntity(row);
  }

  @override
  Future<void> upsertEntry({
    int? existingId,
    required int sessionId,
    required int exerciseId,
    required int totalDurationSeconds,
    int? totalRepetitions,
    required double caloriesBurned,
  }) =>
      _db.exerciseEntryDao.upsert(
        ExerciseEntryTableCompanion(
          id: existingId != null ? Value(existingId) : const Value.absent(),
          sessionId: Value(sessionId),
          exerciseId: Value(exerciseId),
          totalDurationSeconds: Value(totalDurationSeconds),
          totalRepetitions: Value(totalRepetitions),
          caloriesBurned: Value(caloriesBurned),
        ),
      );

  @override
  Future<List<Exercise>> getRecentExercises({int limit = 8}) async {
    final rows = await _db.exerciseEntryDao.getRecentExercises(limit);
    return rows
        .map((r) => Exercise(
              id: r.id,
              name: r.name,
              metValue: r.metValue,
              colorHex: r.colorHex,
              iconName: r.iconName,
              referenceRepsPerMinute: r.referenceRepsPerMinute,
            ))
        .toList();
  }

  @override
  Future<List<ExerciseBreakdownEntry>> getExerciseBreakdownForRange(
      DateTime from, DateTime to) async {
    final rows =
        await _db.exerciseEntryDao.getExerciseBreakdownForRange(from, to);
    return rows
        .map((r) => ExerciseBreakdownEntry(
              exerciseName: r.exerciseName,
              colorHex: r.colorHex,
              totalDurationSeconds: r.totalSeconds,
              totalCalories: r.totalCalories,
            ))
        .toList();
  }

  ExerciseEntry _toEntity(ExerciseEntryWithName row) => ExerciseEntry(
        id: row.entry.id,
        sessionId: row.entry.sessionId,
        exerciseId: row.entry.exerciseId,
        exerciseName: row.exerciseName,
        totalDurationSeconds: row.entry.totalDurationSeconds,
        totalRepetitions: row.entry.totalRepetitions,
        caloriesBurned: row.entry.caloriesBurned,
      );
}

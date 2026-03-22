import 'package:calorhythm/domain/entities/exercise.dart';
import 'package:calorhythm/domain/entities/exercise_entry.dart';
import 'package:calorhythm/domain/entities/exercise_breakdown_entry.dart';

abstract interface class ExerciseEntryRepository {
  /// Returns all entries for a session, joined with exercise name.
  Future<List<ExerciseEntry>> getForSession(int sessionId);

  /// Returns up to [limit] distinct exercises ordered by most recent use.
  Future<List<Exercise>> getRecentExercises({int limit = 8});

  /// Returns the existing entry for (sessionId, exerciseId), or null.
  Future<ExerciseEntry?> getEntry(int sessionId, int exerciseId);

  /// Returns exercise breakdown (name, color, duration) for a date range.
  Future<List<ExerciseBreakdownEntry>> getExerciseBreakdownForRange(
      DateTime from, DateTime to);

  /// Persists an entry. Pass [existingId] to update an existing row;
  /// omit it (null) to insert a new one.
  Future<void> upsertEntry({
    int? existingId,
    required int sessionId,
    required int exerciseId,
    required int totalDurationSeconds,
    int? totalRepetitions,
    required double caloriesBurned,
  });
}

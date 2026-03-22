import 'package:calorhythm/application/services/calorie_calculator.dart';
import 'package:calorhythm/domain/repositories/exercise_entry_repository.dart';
import 'package:calorhythm/domain/repositories/exercise_repository.dart';
import 'package:calorhythm/domain/repositories/workout_session_repository.dart';

/// Records a completed exercise set within an active session.
///
/// Fetches the exercise and session from their repositories, accumulates
/// duration and repetitions onto any existing entry for that exercise,
/// recalculates calories from the new aggregated totals, then persists
/// the result via [ExerciseEntryRepository].
class RecordExerciseSet {
  const RecordExerciseSet({
    required ExerciseRepository exerciseRepository,
    required WorkoutSessionRepository sessionRepository,
    required ExerciseEntryRepository entryRepository,
  })  : _exerciseRepository = exerciseRepository,
        _sessionRepository = sessionRepository,
        _entryRepository = entryRepository;

  final ExerciseRepository _exerciseRepository;
  final WorkoutSessionRepository _sessionRepository;
  final ExerciseEntryRepository _entryRepository;

  Future<void> call({
    required int sessionId,
    required int exerciseId,
    required int addedDurationSeconds,
    int? addedRepetitions,
    bool useRepMultiplier = false,
  }) async {
    final exercise = await _exerciseRepository.getById(exerciseId);
    if (exercise == null)
      throw ArgumentError('Unknown exerciseId: $exerciseId');

    final session = await _sessionRepository.getById(sessionId);
    if (session == null) throw ArgumentError('Unknown sessionId: $sessionId');

    final existing = await _entryRepository.getEntry(sessionId, exerciseId);

    final newDuration =
        (existing?.totalDurationSeconds ?? 0) + addedDurationSeconds;

    final int? newRepetitions;
    if (addedRepetitions != null || existing?.totalRepetitions != null) {
      newRepetitions =
          (existing?.totalRepetitions ?? 0) + (addedRepetitions ?? 0);
    } else {
      newRepetitions = null;
    }

    // Always recalculate from aggregated totals — never sum per-set calories.
    // Reps are always stored for history; useRepMultiplier controls whether
    // they influence the calorie estimate.
    final calories = calculateCalories(
      metValue: exercise.metValue,
      weightKg: session.userWeightKg,
      durationSeconds: newDuration,
      useRepMultiplier: useRepMultiplier,
      actualReps: newRepetitions,
      referenceRepsPerMinute: exercise.referenceRepsPerMinute,
    );

    await _entryRepository.upsertEntry(
      existingId: existing?.id,
      sessionId: sessionId,
      exerciseId: exerciseId,
      totalDurationSeconds: newDuration,
      totalRepetitions: newRepetitions,
      caloriesBurned: calories,
    );
  }
}

/// One exercise's aggregated result within a WorkoutSession.
///
/// Each set of the same exercise in the same session is accumulated here:
/// duration and repetitions are summed; calories are always recalculated
/// from the aggregated totals (never summed per-set).
///
/// UNIQUE constraint: (sessionId, exerciseId) — enforced at the DB level.
class ExerciseEntry {
  const ExerciseEntry({
    required this.id,
    required this.sessionId,
    required this.exerciseId,
    required this.exerciseName,
    required this.totalDurationSeconds,
    required this.caloriesBurned,
    this.totalRepetitions,
  });

  final int id;
  final int sessionId;
  final int exerciseId;

  /// Display name of the exercise (denormalised for convenience).
  final String exerciseName;

  /// Sum of all set durations for this exercise within the session.
  final int totalDurationSeconds;

  /// Sum of all set repetitions. Null if this exercise does not use reps.
  final int? totalRepetitions;

  /// Recalculated from aggregated totals on every set completion.
  final double caloriesBurned;

  Duration get totalDuration => Duration(seconds: totalDurationSeconds);
}

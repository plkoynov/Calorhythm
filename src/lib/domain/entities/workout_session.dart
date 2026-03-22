enum SessionStatus { inProgress, completed, abandoned }

/// A workout session groups one or more exercise entries done in one sitting.
/// Rest time is derived: totalDuration - sum(exerciseEntries.totalDurationSeconds).
class WorkoutSession {
  const WorkoutSession({
    required this.id,
    required this.startTime,
    required this.status,
    required this.userWeightKg,
    this.endTime,
  });

  final int id;
  final DateTime startTime;
  final DateTime? endTime;
  final SessionStatus status;

  /// Snapshot of user weight at session start — used for all calorie calculations
  /// within this session.
  final double userWeightKg;

  Duration? get totalDuration => endTime?.difference(startTime);

  bool get isInProgress => status == SessionStatus.inProgress;
}

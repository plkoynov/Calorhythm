/// Calculates calories burned for an exercise session.
///
/// Formula (MET-based):
///   calories = MET × weightKg × durationHours
///
/// When [useRepMultiplier] is true and both [actualReps] and
/// [referenceRepsPerMinute] are provided:
///   multiplier = actualReps / (referenceRepsPerMinute × durationMinutes)
///   calories   = base_calories × multiplier
double calculateCalories({
  required double metValue,
  required double weightKg,
  required int durationSeconds,
  required bool useRepMultiplier,
  int? actualReps,
  int? referenceRepsPerMinute,
}) {
  final durationHours = durationSeconds / 3600.0;
  final baseCalories = metValue * weightKg * durationHours;

  if (useRepMultiplier &&
      actualReps != null &&
      referenceRepsPerMinute != null &&
      referenceRepsPerMinute > 0) {
    final durationMinutes = durationSeconds / 60.0;
    final expectedReps = referenceRepsPerMinute * durationMinutes;
    if (expectedReps > 0) {
      return baseCalories * (actualReps / expectedReps);
    }
  }

  return baseCalories;
}

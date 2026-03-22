class ExerciseBreakdownEntry {
  const ExerciseBreakdownEntry({
    required this.exerciseName,
    required this.colorHex,
    required this.totalDurationSeconds,
    required this.totalCalories,
  });

  final String exerciseName;
  final String colorHex; // CSS hex e.g. '#EF5350'
  final int totalDurationSeconds;
  final double totalCalories;
}

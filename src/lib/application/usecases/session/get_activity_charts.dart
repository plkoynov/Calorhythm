import 'package:calorhythm/domain/entities/exercise_breakdown_entry.dart';
import 'package:calorhythm/domain/repositories/exercise_entry_repository.dart';
import 'package:calorhythm/domain/repositories/workout_session_repository.dart';

class DailyCalories {
  const DailyCalories({required this.date, required this.calories});

  final DateTime date;
  final double calories;
}

class GetActivityCharts {
  const GetActivityCharts({
    required WorkoutSessionRepository sessionRepository,
    required ExerciseEntryRepository entryRepository,
  })  : _sessionRepository = sessionRepository,
        _entryRepository = entryRepository;

  final WorkoutSessionRepository _sessionRepository;
  final ExerciseEntryRepository _entryRepository;

  /// Pie-chart data: exercise breakdown by total duration for today.
  Future<List<ExerciseBreakdownEntry>> forTodayPieChart() {
    final now = DateTime.now();
    final from = DateTime(now.year, now.month, now.day);
    final to = DateTime(now.year, now.month, now.day, 23, 59, 59);
    return _entryRepository.getExerciseBreakdownForRange(from, to);
  }

  /// Bar-chart data: calories per day for the current week (Mon–Sun).
  Future<List<DailyCalories>> forWeekBarChart() {
    final now = DateTime.now();
    final weekStart = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: now.weekday - 1));
    return _caloriesPerDay(weekStart, 7);
  }

  /// Bar-chart data: calories per day for the current month.
  Future<List<DailyCalories>> forMonthBarChart() {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final daysInMonth =
        DateTime(now.year, now.month + 1, 0).day; // last day of month
    return _caloriesPerDay(monthStart, daysInMonth);
  }

  Future<List<DailyCalories>> _caloriesPerDay(
      DateTime start, int days) async {
    final results = <DailyCalories>[];
    for (int i = 0; i < days; i++) {
      final day = DateTime(start.year, start.month, start.day + i);
      final dayEnd = DateTime(day.year, day.month, day.day, 23, 59, 59);
      final stats = await _sessionRepository.getStatsForRange(day, dayEnd);
      results.add(DailyCalories(date: day, calories: stats.totalCalories));
    }
    return results;
  }
}

import 'package:calorhythm/domain/repositories/workout_session_repository.dart';

class WorkoutStatistics {
  const WorkoutStatistics({
    required this.sessionCount,
    required this.totalCalories,
  });

  final int sessionCount;
  final double totalCalories;
}

class GetStatistics {
  const GetStatistics(this._sessionRepository);

  final WorkoutSessionRepository _sessionRepository;

  Future<WorkoutStatistics> forToday() => _forRange(_todayStart(), _todayEnd());
  Future<WorkoutStatistics> forThisWeek() => _forRange(_weekStart(), _todayEnd());
  Future<WorkoutStatistics> forThisMonth() => _forRange(_monthStart(), _todayEnd());

  Future<WorkoutStatistics> _forRange(DateTime from, DateTime to) async {
    final (:sessionCount, :totalCalories) =
        await _sessionRepository.getStatsForRange(from, to);
    return WorkoutStatistics(
      sessionCount: sessionCount,
      totalCalories: totalCalories,
    );
  }

  DateTime _todayStart() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  DateTime _todayEnd() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, 23, 59, 59);
  }

  DateTime _weekStart() {
    final now = DateTime.now();
    return now.subtract(Duration(days: now.weekday - 1));
  }

  DateTime _monthStart() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, 1);
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:calorhythm/di/app_providers.dart';
import 'package:calorhythm/domain/entities/exercise_breakdown_entry.dart';
import 'package:calorhythm/application/usecases/session/get_activity_charts.dart';
import 'package:calorhythm/application/usecases/session/get_statistics.dart';

part 'home_provider.g.dart';

@riverpod
Future<WorkoutStatistics> todayStats(Ref ref) =>
    ref.watch(getStatisticsProvider).forToday();

@riverpod
Future<WorkoutStatistics> weekStats(Ref ref) =>
    ref.watch(getStatisticsProvider).forThisWeek();

@riverpod
Future<WorkoutStatistics> monthStats(Ref ref) =>
    ref.watch(getStatisticsProvider).forThisMonth();

// ---------------------------------------------------------------------------
// Activity charts
// ---------------------------------------------------------------------------

@riverpod
Future<List<ExerciseBreakdownEntry>> todayPieChart(
        Ref ref) =>
    ref.watch(getActivityChartsProvider).forTodayPieChart();

@riverpod
Future<List<DailyCalories>> weekBarChart(Ref ref) =>
    ref.watch(getActivityChartsProvider).forWeekBarChart();

@riverpod
Future<List<DailyCalories>> monthBarChart(Ref ref) =>
    ref.watch(getActivityChartsProvider).forMonthBarChart();

@riverpod
Future<bool> hasAnyActivity(Ref ref) async {
  final results = await Future.wait([
    ref.watch(todayStatsProvider.future),
    ref.watch(weekStatsProvider.future),
    ref.watch(monthStatsProvider.future),
  ]);
  return results.any((s) => s.sessionCount > 0);
}

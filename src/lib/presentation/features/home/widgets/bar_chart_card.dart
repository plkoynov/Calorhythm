import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:calorhythm/application/usecases/session/get_activity_charts.dart';

/// Reusable bar chart card for weekly and monthly views.
class BarChartCard extends StatelessWidget {
  const BarChartCard({
    super.key,
    required this.dataAsync,
    required this.labelBuilder,
  });

  final AsyncValue<List<DailyCalories>> dataAsync;

  /// Returns a short x-axis label for a given [DailyCalories] entry.
  final String Function(DailyCalories) labelBuilder;

  static const _barColor = Color(0xFF42A5F5);
  static const _barWidth = 10.0;

  @override
  Widget build(BuildContext context) {
    return dataAsync.when(
      loading: () => const SizedBox(
        height: 160,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Text('Error: $e'),
      data: (days) {
        final maxCal =
            days.fold<double>(0, (m, d) => d.calories > m ? d.calories : m);

        return SizedBox(
          height: 160,
          child: BarChart(
            BarChartData(
              maxY: maxCal > 0 ? maxCal * 1.2 : 100,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (v) => FlLine(
                  color: Colors.grey.withValues(alpha: 0.15),
                  strokeWidth: 1,
                ),
              ),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                leftTitles: const AxisTitles(),
                rightTitles: const AxisTitles(),
                topTitles: const AxisTitles(),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 24,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < 0 || index >= days.length) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          labelBuilder(days[index]),
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(fontSize: 10),
                        ),
                      );
                    },
                  ),
                ),
              ),
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (group, _, rod, __) => BarTooltipItem(
                    '${rod.toY.toStringAsFixed(0)} kcal',
                    Theme.of(context)
                        .textTheme
                        .labelSmall!
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
              barGroups: days.asMap().entries.map((e) {
                final today = DateTime.now();
                final isToday = e.value.date.year == today.year &&
                    e.value.date.month == today.month &&
                    e.value.date.day == today.day;
                return BarChartGroupData(
                  x: e.key,
                  barRods: [
                    BarChartRodData(
                      toY: e.value.calories,
                      color: isToday
                          ? Theme.of(context).colorScheme.primary
                          : _barColor,
                      width: _barWidth,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(4),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}

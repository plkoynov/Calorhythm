import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:calorhythm/presentation/features/home/providers/home_provider.dart';

class MonthlyChartCard extends ConsumerWidget {
  const MonthlyChartCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(monthBarChartProvider);

    return dataAsync.when(
              loading: () => const SizedBox(
                height: 160,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => Text('Error: $e'),
              data: (days) {
                final maxCal = days.fold<double>(
                    0, (m, d) => d.calories > m ? d.calories : m);
                final today = DateTime.now().day;

                final spots = days
                    .map((d) => FlSpot(
                          d.date.day.toDouble(),
                          d.calories,
                        ))
                    .toList();

                return SizedBox(
                  height: 160,
                  child: LineChart(
                    LineChartData(
                      maxY: maxCal > 0 ? maxCal * 1.2 : 100,
                      minY: 0,
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        getDrawingHorizontalLine: (v) => FlLine(
                          color: Colors.grey.withValues(alpha: 0.15),
                          strokeWidth: 1,
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      lineTouchData: LineTouchData(
                        touchTooltipData: LineTouchTooltipData(
                          getTooltipItems: (spots) => spots
                              .map((spot) => LineTooltipItem(
                                    '${spot.y.toStringAsFixed(0)} kcal',
                                    Theme.of(context)
                                        .textTheme
                                        .labelSmall!
                                        .copyWith(color: Colors.white),
                                  ))
                              .toList(),
                        ),
                      ),
                      titlesData: FlTitlesData(
                        rightTitles: const AxisTitles(),
                        topTitles: const AxisTitles(),
                        leftTitles: const AxisTitles(),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 24,
                            interval: 5,
                            getTitlesWidget: (value, meta) {
                              final day = value.toInt();
                              if (day % 5 != 0) return const SizedBox.shrink();
                              return SideTitleWidget(
                                meta: meta,
                                child: Text(
                                  '$day',
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
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          curveSmoothness: 0.3,
                          color: const Color(0xFF42A5F5),
                          barWidth: 2,
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, _, __, ___) {
                              final isToday = spot.x.toInt() == today;
                              return FlDotCirclePainter(
                                radius: isToday ? 4 : 2.5,
                                color: isToday
                                    ? Theme.of(context).colorScheme.primary
                                    : const Color(0xFF42A5F5),
                                strokeWidth: 0,
                              );
                            },
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            color: const Color(0xFF42A5F5).withValues(alpha: 0.08),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
    );
  }
}

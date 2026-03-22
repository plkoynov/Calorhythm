import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:calorhythm/presentation/features/profile/providers/profile_provider.dart';
import 'package:calorhythm/presentation/features/home/providers/home_provider.dart';
import 'package:calorhythm/presentation/features/home/widgets/bar_chart_card.dart';
import 'package:calorhythm/presentation/features/home/widgets/chart_toggle.dart';
import 'package:calorhythm/presentation/features/home/widgets/daily_activity_card.dart';
import 'package:calorhythm/presentation/features/home/widgets/empty_activity_view.dart';
import 'package:calorhythm/presentation/features/home/widgets/home_greeting.dart';
import 'package:calorhythm/presentation/features/home/widgets/monthly_chart_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _showWeekly = true;

  @override
  Widget build(BuildContext context) {
    final hasActivityAsync = ref.watch(hasAnyActivityProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Calorhythm')),
      body: hasActivityAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (hasActivity) => hasActivity
            ? ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  HomeGreeting(
                      name: ref.watch(userProfileProvider).valueOrNull?.name),
                  const SizedBox(height: 20),
                  const DailyActivityCard(),
                  const SizedBox(height: 32),
                  ChartToggle(
                    showWeekly: _showWeekly,
                    onChanged: (v) => setState(() => _showWeekly = v),
                  ),
                  const SizedBox(height: 8),
                  if (_showWeekly)
                    BarChartCard(
                      dataAsync: ref.watch(weekBarChartProvider),
                      labelBuilder: (d) => _weekdayLabel(d.date.weekday),
                    )
                  else
                    const MonthlyChartCard(),
                ],
              )
            : const EmptyActivityView(),
      ),
    );
  }

  String _weekdayLabel(int weekday) => switch (weekday) {
        1 => 'Mon',
        2 => 'Tue',
        3 => 'Wed',
        4 => 'Thu',
        5 => 'Fri',
        6 => 'Sat',
        _ => 'Sun',
      };
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:calorhythm/presentation/constants/app_strings.dart';
import 'package:calorhythm/presentation/features/history/providers/history_provider.dart';
import 'package:calorhythm/presentation/features/history/widgets/empty_history_view.dart';
import 'package:calorhythm/presentation/features/history/widgets/session_list_item.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(workoutHistoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.historyTitle)),
      body: historyAsync.when(
        data: (sessions) => sessions.isEmpty
            ? const EmptyHistoryView()
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: sessions.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) =>
                    SessionListItem(session: sessions[index]),
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

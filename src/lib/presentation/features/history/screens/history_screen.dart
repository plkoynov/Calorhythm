import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:calorhythm/presentation/constants/app_strings.dart';
import 'package:calorhythm/presentation/features/history/providers/history_provider.dart';
import 'package:calorhythm/presentation/features/history/widgets/empty_history_view.dart';
import 'package:calorhythm/presentation/features/history/widgets/history_filter_chips.dart';
import 'package:calorhythm/presentation/features/history/widgets/no_filter_results_view.dart';
import 'package:calorhythm/presentation/features/history/widgets/session_list_item.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final pos = _scrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - 200) {
      ref.read(workoutHistoryNotifierProvider.notifier).loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final historyAsync = ref.watch(workoutHistoryNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.historyTitle)),
      body: historyAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (state) {
          if (state.sessions.isEmpty && !state.filter.isActive) {
            return const EmptyHistoryView();
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HistoryFilterChips(),
              Expanded(
                child: state.sessions.isEmpty
                    ? const NoFilterResultsView()
                    : ListView.separated(
                        controller: _scrollController,
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        itemCount:
                            state.sessions.length + (state.hasMore ? 1 : 0),
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          if (index == state.sessions.length) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                          return SessionListItem(
                              session: state.sessions[index]);
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

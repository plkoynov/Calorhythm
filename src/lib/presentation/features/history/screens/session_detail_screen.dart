import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:calorhythm/presentation/extensions/datetime_extension.dart';
import 'package:calorhythm/domain/entities/workout_session.dart';
import 'package:calorhythm/presentation/router/app_router.dart';
import 'package:calorhythm/presentation/features/history/providers/history_provider.dart';
import 'package:calorhythm/presentation/features/history/widgets/exercise_entry_tile.dart';

class SessionDetailScreen extends ConsumerWidget {
  const SessionDetailScreen({super.key, required this.session});

  final WorkoutSession session;

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete session'),
        content: const Text(
          'This will permanently delete this session and all its recorded exercises. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    await ref.read(deleteSessionProvider(session.id).future);

    if (context.mounted) context.go(AppRoutes.history);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(sessionDetailEntriesProvider(session.id));

    final String durationLabel;
    if (session.endTime != null) {
      final secs = session.endTime!.difference(session.startTime).inSeconds;
      durationLabel = secs.asTimerLabel;
    } else {
      durationLabel = 'In progress';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(session.startTime.dateLabel),
        actions: [
          IconButton(
            icon: Icon(
              Icons.delete_outline,
              color: Theme.of(context).colorScheme.error,
            ),
            tooltip: 'Delete session',
            onPressed: () => _confirmDelete(context, ref),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(24),
          child: Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${session.startTime.timeLabel}  •  $durationLabel',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
        ),
      ),
      body: entriesAsync.when(
        data: (entries) => entries.isEmpty
            ? const Center(child: Text('No exercises recorded.'))
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: entries.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) =>
                    ExerciseEntryTile(entry: entries[index]),
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

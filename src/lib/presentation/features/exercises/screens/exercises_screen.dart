import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:calorhythm/presentation/features/exercises/providers/exercises_provider.dart';
import 'package:calorhythm/presentation/features/exercises/widgets/active_session_view.dart';
import 'package:calorhythm/presentation/features/exercises/widgets/no_session_view.dart';

class ExercisesScreen extends ConsumerWidget {
  const ExercisesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionAsync = ref.watch(activeSessionProvider);

    return sessionAsync.when(
      data: (session) => session == null
          ? NoSessionView(
              onStart: () =>
                  ref.read(sessionManagerProvider.notifier).startSession())
          : ActiveSessionView(session: session),
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        body: Center(child: Text('Error: $e')),
      ),
    );
  }
}

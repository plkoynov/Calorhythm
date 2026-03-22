import 'package:flutter/material.dart';

import 'package:calorhythm/presentation/features/exercises/providers/timer_provider.dart';

class TimerControls extends StatelessWidget {
  const TimerControls({
    super.key,
    required this.status,
    required this.saving,
    required this.onStart,
    required this.onPause,
    required this.onResume,
    required this.onFinish,
    required this.onAnotherSet,
  });

  final TimerStatus status;
  final bool saving;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onFinish;
  final VoidCallback onAnotherSet;

  @override
  Widget build(BuildContext context) {
    if (saving) {
      return const CircularProgressIndicator();
    }

    return switch (status) {
      TimerStatus.idle => FilledButton.icon(
          onPressed: onStart,
          icon: const Icon(Icons.play_arrow_rounded),
          label: const Text('Start'),
        ),
      TimerStatus.running => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton.icon(
              onPressed: onPause,
              icon: const Icon(Icons.pause_rounded),
              label: const Text('Pause'),
            ),
            const SizedBox(width: 16),
            FilledButton.icon(
              onPressed: onFinish,
              icon: const Icon(Icons.stop_rounded),
              label: const Text('Finish'),
            ),
          ],
        ),
      TimerStatus.paused => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilledButton.icon(
              onPressed: onResume,
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Resume'),
            ),
            const SizedBox(width: 16),
            OutlinedButton.icon(
              onPressed: onFinish,
              icon: const Icon(Icons.stop_rounded),
              label: const Text('Finish'),
            ),
          ],
        ),
      TimerStatus.stopped => Column(
          children: [
            FilledButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.check_rounded),
              label: const Text('Back to Workout'),
            ),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: onAnotherSet,
              icon: const Icon(Icons.replay_rounded),
              label: const Text('Do another set'),
            ),
          ],
        ),
    };
  }
}

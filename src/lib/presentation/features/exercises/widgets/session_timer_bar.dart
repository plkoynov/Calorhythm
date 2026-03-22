import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:calorhythm/domain/entities/workout_session.dart';
import 'package:calorhythm/presentation/features/exercises/providers/session_clock_provider.dart';
import 'package:calorhythm/presentation/features/exercises/widgets/bar_button.dart';

class SessionTimerBar extends ConsumerStatefulWidget {
  const SessionTimerBar({
    super.key,
    required this.session,
    required this.onFinish,
    required this.onAbandon,
  });

  final WorkoutSession session;
  final VoidCallback onFinish;
  final VoidCallback onAbandon;

  @override
  ConsumerState<SessionTimerBar> createState() => _SessionTimerBarState();
}

class _SessionTimerBarState extends ConsumerState<SessionTimerBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _dotController;

  @override
  void initState() {
    super.initState();
    _dotController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _dotController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final elapsed = ref.watch(
      sessionClockProvider(widget.session.startTime),
    );

    return Container(
      color: const Color(0xFF111827),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          FadeTransition(
            opacity: _dotController.drive(Tween(begin: 0.4, end: 1.0)),
            child: Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Colors.redAccent,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 6),
          const Text(
            'REC',
            style: TextStyle(
              color: Colors.redAccent,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.4,
            ),
          ),
          const Spacer(),
          Text(
            _format(elapsed),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w300,
              fontFeatures: [FontFeature.tabularFigures()],
              letterSpacing: 2,
            ),
          ),
          const Spacer(),
          BarButton(
            icon: Icons.check_circle_outline_rounded,
            color: Colors.greenAccent,
            tooltip: 'Finish workout',
            onTap: widget.onFinish,
          ),
          BarButton(
            icon: Icons.cancel_outlined,
            color: Colors.redAccent,
            tooltip: 'Abandon workout',
            onTap: widget.onAbandon,
          ),
        ],
      ),
    );
  }

  String _format(int seconds) {
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;
    final s = seconds % 60;
    final mm = m.toString().padLeft(2, '0');
    final ss = s.toString().padLeft(2, '0');
    if (h > 0) return '${h.toString().padLeft(2, '0')}:$mm:$ss';
    return '$mm:$ss';
  }
}

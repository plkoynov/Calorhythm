import 'dart:math';

import 'package:flutter/material.dart';

import 'package:calorhythm/presentation/extensions/datetime_extension.dart';
import 'package:calorhythm/presentation/features/exercises/providers/timer_provider.dart';

class CircularTimer extends StatelessWidget {
  const CircularTimer({super.key, required this.timerState});

  final TimerState timerState;

  static const _lapColors = [
    Color(0xFF4CAF50),
    Color(0xFF2196F3),
    Color(0xFF9C27B0),
    Color(0xFFFF9800),
    Color(0xFFE91E63),
  ];

  @override
  Widget build(BuildContext context) {
    final elapsed = timerState.elapsedSeconds;
    final lapIndex = elapsed ~/ 60;
    final progress =
        timerState.status == TimerStatus.idle ? 0.0 : (elapsed % 60) / 60.0;
    final color = _lapColors[lapIndex % _lapColors.length];

    return SizedBox(
      width: 220,
      height: 220,
      child: CustomPaint(
        painter: _ArcPainter(
          progress: progress,
          color: color,
          isIdle: timerState.status == TimerStatus.idle,
          isPaused: timerState.status == TimerStatus.paused,
        ),
        child: Center(
          child: Text(
            elapsed.asTimerLabel,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w300,
                  letterSpacing: 3,
                ),
          ),
        ),
      ),
    );
  }
}

class _ArcPainter extends CustomPainter {
  const _ArcPainter({
    required this.progress,
    required this.color,
    required this.isIdle,
    required this.isPaused,
  });

  final double progress;
  final Color color;
  final bool isIdle;
  final bool isPaused;

  static const _strokeWidth = 14.0;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - _strokeWidth / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = (isPaused ? Colors.grey : color).withValues(alpha: 0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = _strokeWidth,
    );

    if (!isIdle && progress > 0) {
      canvas.drawArc(
        rect,
        -pi / 2,
        2 * pi * progress,
        false,
        Paint()
          ..color = isPaused ? Colors.grey : color
          ..style = PaintingStyle.stroke
          ..strokeWidth = _strokeWidth
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(_ArcPainter old) =>
      old.progress != progress ||
      old.color != color ||
      old.isPaused != isPaused;
}

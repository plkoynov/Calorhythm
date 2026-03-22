import 'dart:math';

import 'package:flutter/material.dart';

import 'package:calorhythm/domain/entities/exercise_breakdown_entry.dart';
import 'package:calorhythm/presentation/features/home/widgets/legend_item.dart';

class ConcentricSection extends StatelessWidget {
  const ConcentricSection({super.key, required this.entries});

  final List<ExerciseBreakdownEntry> entries;

  static Color _parseColor(String hex) {
    final clean = hex.replaceFirst('#', '');
    return Color(int.parse('FF$clean', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final total = entries.fold<double>(0, (sum, e) => sum + e.totalCalories);

    final rings = entries
        .map((e) => (
              color: _parseColor(e.colorHex),
              proportion: total > 0 ? e.totalCalories / total : 0.0,
            ))
        .toList();

    return Row(
      children: [
        SizedBox(
          width: 150,
          height: 150,
          child: CustomPaint(
            painter: _ConcentricPainter(rings: rings),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: entries.map((e) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: LegendItem(
                  color: _parseColor(e.colorHex),
                  label: e.exerciseName,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _ConcentricPainter extends CustomPainter {
  const _ConcentricPainter({required this.rings});

  final List<({Color color, double proportion})> rings;

  static const _strokeWidth = 11.0;
  static const _gap = 6.0;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2 - _strokeWidth / 2;

    for (int i = 0; i < rings.length; i++) {
      final radius = maxRadius - i * (_strokeWidth + _gap);
      if (radius <= _strokeWidth / 2) break;

      final ring = rings[i];
      final rect = Rect.fromCircle(center: center, radius: radius);

      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..color = ring.color.withValues(alpha: 0.15)
          ..style = PaintingStyle.stroke
          ..strokeWidth = _strokeWidth,
      );

      if (ring.proportion > 0) {
        canvas.drawArc(
          rect,
          -pi / 2,
          2 * pi * ring.proportion,
          false,
          Paint()
            ..color = ring.color
            ..style = PaintingStyle.stroke
            ..strokeWidth = _strokeWidth
            ..strokeCap = StrokeCap.round,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_ConcentricPainter old) => old.rings != rings;
}

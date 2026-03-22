import 'package:flutter/material.dart';

import 'package:calorhythm/domain/entities/workout_session.dart';

class SessionStatusBadge extends StatelessWidget {
  const SessionStatusBadge({super.key, required this.status});

  final SessionStatus status;

  @override
  Widget build(BuildContext context) {
    final (background, border, foreground, label) = switch (status) {
      SessionStatus.completed => (
          const Color(0xFF2E7D32),
          const Color(0xFF1B5E20),
          Colors.white,
          'Completed',
        ),
      SessionStatus.inProgress => (
          const Color(0xFFFFF8E1),
          const Color(0xFFF9A825),
          const Color(0xFF5D4037),
          'In progress',
        ),
      SessionStatus.abandoned => (
          const Color(0xFFC62828),
          const Color(0xFF7F0000),
          Colors.white,
          'Abandoned',
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border, width: 1.5),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: foreground,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

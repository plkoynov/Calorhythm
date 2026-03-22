import 'package:flutter/material.dart';

class EmptyRecentMessage extends StatelessWidget {
  const EmptyRecentMessage({super.key, required this.sessionId});

  final int sessionId;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Text(
              'No recent exercises yet.\nTap + to find an exercise and get started.',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      );
}

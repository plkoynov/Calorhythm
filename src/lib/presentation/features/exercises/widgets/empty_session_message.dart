import 'package:flutter/material.dart';

class EmptySessionMessage extends StatelessWidget {
  const EmptySessionMessage({super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(
          'No exercises yet.\nChoose one from the list below.',
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Colors.grey),
        ),
      );
}

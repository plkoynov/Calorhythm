import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:calorhythm/presentation/constants/app_strings.dart';

class RepInputDialog extends StatefulWidget {
  const RepInputDialog({super.key});

  @override
  State<RepInputDialog> createState() => _RepInputDialogState();
}

class _RepInputDialogState extends State<RepInputDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(AppStrings.enterReps),
      content: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        autofocus: true,
        decoration: const InputDecoration(
          hintText: 'e.g. 30',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: const Text(AppStrings.skip),
        ),
        FilledButton(
          onPressed: () {
            final reps = int.tryParse(_controller.text);
            Navigator.of(context).pop(reps);
          },
          child: const Text(AppStrings.done),
        ),
      ],
    );
  }
}

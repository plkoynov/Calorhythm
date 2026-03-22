import 'package:flutter/material.dart';

import 'package:calorhythm/domain/entities/workout_session.dart';

class StatusPickerSheet extends StatefulWidget {
  const StatusPickerSheet({super.key, required this.initial});

  final Set<SessionStatus> initial;

  @override
  State<StatusPickerSheet> createState() => _StatusPickerSheetState();
}

class _StatusPickerSheetState extends State<StatusPickerSheet> {
  late Set<SessionStatus> _selected;

  static const _all = [
    SessionStatus.completed,
    SessionStatus.inProgress,
    SessionStatus.abandoned,
  ];

  static String _label(SessionStatus s) => switch (s) {
        SessionStatus.completed => 'Completed',
        SessionStatus.inProgress => 'In progress',
        SessionStatus.abandoned => 'Abandoned',
      };

  @override
  void initState() {
    super.initState();
    _selected = Set.from(widget.initial);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Text(
                'Filter by status',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            ..._all.map(
              (s) => CheckboxListTile(
                title: Text(_label(s)),
                value: _selected.contains(s),
                onChanged: (checked) {
                  setState(() {
                    if (checked == true) {
                      _selected.add(s);
                    } else {
                      _selected.remove(s);
                    }
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: () => Navigator.pop(context, _selected),
                    child: const Text('Apply'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

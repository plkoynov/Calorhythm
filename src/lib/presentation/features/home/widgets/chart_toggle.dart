import 'package:flutter/material.dart';

class ChartToggle extends StatelessWidget {
  const ChartToggle({
    super.key,
    required this.showWeekly,
    required this.onChanged,
  });

  final bool showWeekly;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final onPrimary = Theme.of(context).colorScheme.onPrimary;

    return SegmentedButton<bool>(
      segments: const [
        ButtonSegment(value: true, label: Text('Weekly')),
        ButtonSegment(value: false, label: Text('Monthly')),
      ],
      selected: {showWeekly},
      showSelectedIcon: false,
      onSelectionChanged: (s) => onChanged(s.first),
      style: ButtonStyle(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
        backgroundColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? primary : null,
        ),
        foregroundColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? onPrimary : null,
        ),
      ),
    );
  }
}

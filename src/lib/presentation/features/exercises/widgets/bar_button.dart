import 'package:flutter/material.dart';

class BarButton extends StatelessWidget {
  const BarButton({
    super.key,
    required this.icon,
    required this.color,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => IconButton(
        icon: Icon(icon, color: color),
        tooltip: tooltip,
        onPressed: onTap,
        visualDensity: VisualDensity.compact,
      );
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:calorhythm/presentation/router/app_routes.dart';
import 'package:calorhythm/presentation/router/widgets/nav_item.dart';

typedef _Destination = ({IconData icon, String label, String route});

const _destinations = <_Destination>[
  (icon: Icons.home_outlined, label: 'Home', route: AppRoutes.home),
  (icon: Icons.fitness_center_outlined, label: 'Workout', route: AppRoutes.workout),
  (icon: Icons.history_outlined, label: 'History', route: AppRoutes.history),
  (icon: Icons.person_outline, label: 'Profile', route: AppRoutes.profile),
];

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final selectedIndex = _indexForLocation(location);

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFFFFFF),
        border: Border(top: BorderSide(color: Color(0xFFE0E0E0))),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (final (i, dest) in _destinations.indexed)
              NavItem(
                icon: dest.icon,
                label: dest.label,
                selected: i == selectedIndex,
                onTap: () => context.go(dest.route),
              ),
          ],
        ),
      ),
    );
  }

  int _indexForLocation(String location) {
    if (location.startsWith(AppRoutes.workout)) return 1;
    if (location.startsWith(AppRoutes.history)) return 2;
    if (location.startsWith(AppRoutes.profile)) return 3;
    return 0;
  }
}

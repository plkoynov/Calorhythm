import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:calorhythm/domain/entities/workout_session.dart';
import 'package:calorhythm/presentation/features/exercises/screens/exercise_timer_screen.dart';
import 'package:calorhythm/presentation/features/exercises/screens/exercises_screen.dart';
import 'package:calorhythm/presentation/features/history/screens/history_screen.dart';
import 'package:calorhythm/presentation/features/history/screens/session_detail_screen.dart';
import 'package:calorhythm/presentation/features/home/screens/home_screen.dart';
import 'package:calorhythm/presentation/features/profile/screens/profile_screen.dart';
import 'package:calorhythm/presentation/router/app_routes.dart';
import 'package:calorhythm/presentation/router/widgets/scaffold_with_nav_bar.dart';

export 'package:calorhythm/presentation/router/app_routes.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.home,
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => ScaffoldWithNavBar(child: child),
      routes: [
        GoRoute(
          path: AppRoutes.home,
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: AppRoutes.workout,
          builder: (context, state) => const ExercisesScreen(),
        ),
        GoRoute(
          path: AppRoutes.history,
          builder: (context, state) => const HistoryScreen(),
          routes: [
            GoRoute(
              path: ':id',
              builder: (context, state) {
                final session = state.extra as WorkoutSession;
                return SessionDetailScreen(session: session);
              },
            ),
          ],
        ),
        GoRoute(
          path: AppRoutes.profile,
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
    GoRoute(
      path: AppRoutes.exerciseTimer,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return ExerciseTimerScreen(exerciseId: id);
      },
    ),
  ],
);

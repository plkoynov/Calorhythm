# Presentation Layer

## Before Starting Any Task

You MUST:
- Read the full layer specification: [`docs/rules/presentation.md`](../../../../docs/rules/presentation.md)
- Follow all rules defined in [`docs/rules/architecture.md`](../../../../docs/rules/architecture.md) and [`docs/rules/coding.md`](../../../../docs/rules/coding.md)
- Validate that no dependency rule is violated
- Ensure code placement matches the layer definition above
- If the task touches multiple layers, read each affected layer's `AGENTS.md` before proceeding

## Coding Conventions

Global conventions (one primary class per file, absolute imports, generated files) are defined in [`docs/rules/coding.md`](../../../../docs/rules/coding.md).

Layer-specific:
- One widget per file — every widget (screen or component) has its own file, regardless of whether it is used only in one parent
  - Exception: a `StatefulWidget` and its `State` subclass may coexist in the same file
  - Exception: a `CustomPainter` companion may coexist in the same file as the widget that exclusively owns it

## Examples

```dart
// presentation/features/workout/providers/workout_history_provider.dart
@riverpod
Future<List<WorkoutSession>> workoutHistory(WorkoutHistoryRef ref) =>
    ref.watch(getWorkoutHistoryProvider).execute();
```

```dart
// presentation/features/workout/screens/workout_history_screen.dart
class WorkoutHistoryScreen extends ConsumerWidget {
  const WorkoutHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(workoutHistoryProvider);
    return history.when(
      data: (sessions) => SessionList(sessions: sessions),
      loading: () => const CircularProgressIndicator(),
      error: (e, _) => Text('Error: $e'),
    );
  }
}
```

```dart
// presentation/features/workout/widgets/session_list.dart
class SessionList extends StatelessWidget {
  final List<WorkoutSession> sessions;

  const SessionList({super.key, required this.sessions});

  @override
  Widget build(BuildContext context) => ListView.builder(
    itemCount: sessions.length,
    itemBuilder: (_, i) => SessionTile(session: sessions[i]),
  );
}
```

## Self-Validation

Before finishing, verify:
- [ ] `flutter analyze` reports no new errors or warnings
- [ ] All new files are placed inside `lib/presentation/`
- [ ] No import from `package:calorhythm/infrastructure` was introduced (ignore `.g.dart` files)

**If a check fails:**
1. Attempt to fix the violation — if infrastructure is imported directly, wire the dependency through a provider in `di/` instead; if a widget contains other widgets, extract each into its own file
2. If the fix succeeds, re-run the checklist from the top
3. If the fix cannot be applied, emit the block below and STOP — do not complete the task

```
[LAYER VIOLATION]
Layer   : presentation
Rule    : <rule broken>
File    : <file path>
Detail  : <what was found>
Fix     : <what must change before this task can be completed>
```

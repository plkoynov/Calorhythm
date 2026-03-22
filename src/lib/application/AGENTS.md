# Application Layer

## Before Starting Any Task

You MUST:
- Read the full layer specification: [`docs/rules/application.md`](../../../../docs/rules/application.md)
- Follow all rules defined in [`docs/rules/architecture.md`](../../../../docs/rules/architecture.md) and [`docs/rules/coding.md`](../../../../docs/rules/coding.md)
- Validate that no dependency rule is violated
- Ensure code placement matches the layer definition above
- If the task touches multiple layers, read each affected layer's `AGENTS.md` before proceeding

## Coding Conventions

Global conventions (one primary class per file, absolute imports, generated files) are defined in [`docs/rules/coding.md`](../../../../docs/rules/coding.md).

No additional layer-specific conventions.

## Examples

```dart
// application/usecases/save_workout_session.dart
class SaveWorkoutSession {
  final WorkoutSessionRepository _repository;

  SaveWorkoutSession(this._repository);

  Future<void> execute(WorkoutSession session) =>
      _repository.save(session);
}
```

```dart
// application/usecases/get_workout_history.dart
class GetWorkoutHistory {
  final WorkoutSessionRepository _repository;

  GetWorkoutHistory(this._repository);

  Future<List<WorkoutSession>> execute() => _repository.getAll();
}
```

```dart
// application/services/calorie_calculator.dart
class CalorieCalculator {
  double calculate({required double met, required double weightKg, required Duration duration}) {
    return met * weightKg * duration.inMinutes / 60;
  }
}
```

## Self-Validation

Before finishing, verify:
- [ ] `flutter analyze` reports no new errors or warnings
- [ ] All new files are placed inside `lib/application/`
- [ ] No import from `package:flutter`, `package:calorhythm/infrastructure`, `package:calorhythm/presentation`, or `package:calorhythm/di` was introduced (ignore `.g.dart` files)

**If a check fails:**
1. Attempt to fix the violation — if Flutter is imported, the code belongs in `presentation/`; if infrastructure is imported, wire it through `di/` instead
2. If the fix succeeds, re-run the checklist from the top
3. If the fix cannot be applied, emit the block below and STOP — do not complete the task

```
[LAYER VIOLATION]
Layer   : application
Rule    : <rule broken>
File    : <file path>
Detail  : <what was found>
Fix     : <what must change before this task can be completed>
```

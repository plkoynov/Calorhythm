# Dependency Injection

## Before Starting Any Task

You MUST:
- Read the full layer specification: [`docs/rules/di.md`](../../../../docs/rules/di.md)
- Follow all rules defined in [`docs/rules/architecture.md`](../../../../docs/rules/architecture.md) and [`docs/rules/coding.md`](../../../../docs/rules/coding.md)
- Validate that no dependency rule is violated
- Ensure code placement matches the layer definition above
- If the task touches multiple layers, read each affected layer's `AGENTS.md` before proceeding

## Coding Conventions

Global conventions (one primary class per file, absolute imports, generated files) are defined in [`docs/rules/coding.md`](../../../../docs/rules/coding.md).

No additional layer-specific conventions.

## Examples

```dart
// di/app_providers.dart

@riverpod
AppDatabase appDatabase(AppDatabaseRef ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
}

@riverpod
WorkoutSessionRepository workoutSessionRepository(
  WorkoutSessionRepositoryRef ref,
) => DriftWorkoutSessionRepository(ref.watch(appDatabaseProvider));

@riverpod
GetWorkoutHistory getWorkoutHistory(GetWorkoutHistoryRef ref) =>
    GetWorkoutHistory(ref.watch(workoutSessionRepositoryProvider));

@riverpod
SaveWorkoutSession saveWorkoutSession(SaveWorkoutSessionRef ref) =>
    SaveWorkoutSession(ref.watch(workoutSessionRepositoryProvider));
```

## Self-Validation

Before finishing, verify:
- [ ] `flutter analyze` reports no new errors or warnings
- [ ] All new files are placed inside `lib/di/`
- [ ] No business logic or UI code was introduced — providers only instantiate and bind (ignore `.g.dart` files)

**If a check fails:**
1. Attempt to fix the violation — move business logic to `application/` or `infrastructure/`; move UI code to `presentation/`
2. If the fix succeeds, re-run the checklist from the top
3. If the fix cannot be applied, emit the block below and STOP — do not complete the task

```
[LAYER VIOLATION]
Layer   : di
Rule    : <rule broken>
File    : <file path>
Detail  : <what was found>
Fix     : <what must change before this task can be completed>
```

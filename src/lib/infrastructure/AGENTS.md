# Infrastructure Layer

## Before Starting Any Task

You MUST:
- Read the full layer specification: [`docs/rules/infrastructure.md`](../../../../docs/rules/infrastructure.md)
- Follow all rules defined in [`docs/rules/architecture.md`](../../../../docs/rules/architecture.md) and [`docs/rules/coding.md`](../../../../docs/rules/coding.md)
- Validate that no dependency rule is violated
- Ensure code placement matches the layer definition above
- If the task touches multiple layers, read each affected layer's `AGENTS.md` before proceeding

## Coding Conventions

Global conventions (one primary class per file, absolute imports, generated files) are defined in [`docs/rules/coding.md`](../../../../docs/rules/coding.md).

No additional layer-specific conventions.

## Examples

```dart
// infrastructure/persistence/repositories/drift_workout_session_repository.dart
class DriftWorkoutSessionRepository implements WorkoutSessionRepository {
  final AppDatabase _db;

  DriftWorkoutSessionRepository(this._db);

  @override
  Future<List<WorkoutSession>> getAll() async {
    final rows = await _db.workoutSessionDao.findAll();
    return rows.map((r) => WorkoutSession(
      id: r.id,
      startedAt: r.startedAt,
      duration: Duration(seconds: r.durationSeconds),
    )).toList();
  }

  @override
  Future<void> save(WorkoutSession session) =>
      _db.workoutSessionDao.upsert(session);

  @override
  Future<void> delete(String id) =>
      _db.workoutSessionDao.deleteById(id);
}
```

## Self-Validation

Before finishing, verify:
- [ ] `flutter analyze` reports no new errors or warnings
- [ ] All new files are placed inside `lib/infrastructure/`
- [ ] No import from `package:calorhythm/application`, `package:calorhythm/presentation`, or `package:calorhythm/di` was introduced (ignore `.g.dart` files)

**If a check fails:**
1. Attempt to fix the violation — if application or presentation logic is needed, it likely belongs in those layers; if a circular dependency appears, introduce a domain interface to break it
2. If the fix succeeds, re-run the checklist from the top
3. If the fix cannot be applied, emit the block below and STOP — do not complete the task

```
[LAYER VIOLATION]
Layer   : infrastructure
Rule    : <rule broken>
File    : <file path>
Detail  : <what was found>
Fix     : <what must change before this task can be completed>
```

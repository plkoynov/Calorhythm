# Domain Layer

## Before Starting Any Task

You MUST:
- Read the full layer specification: [`docs/rules/domain.md`](../../../../docs/rules/domain.md)
- Follow all rules defined in [`docs/rules/architecture.md`](../../../../docs/rules/architecture.md) and [`docs/rules/coding.md`](../../../../docs/rules/coding.md)
- Validate that no dependency rule is violated
- Ensure code placement matches the layer definition above
- If the task touches multiple layers, read each affected layer's `AGENTS.md` before proceeding

## Coding Conventions

Global conventions (one primary class per file, absolute imports, generated files) are defined in [`docs/rules/coding.md`](../../../../docs/rules/coding.md).

Layer-specific:
- Entities must be immutable where possible

## Examples

```dart
// domain/entities/workout_session.dart
class WorkoutSession {
  final String id;
  final DateTime startedAt;
  final Duration duration;

  const WorkoutSession({
    required this.id,
    required this.startedAt,
    required this.duration,
  });
}
```

```dart
// domain/repositories/workout_session_repository.dart
abstract interface class WorkoutSessionRepository {
  Future<List<WorkoutSession>> getAll();
  Future<void> save(WorkoutSession session);
  Future<void> delete(String id);
}
```

## Self-Validation

Before finishing, verify:
- [ ] `flutter analyze` reports no new errors or warnings
- [ ] All new files are placed inside `lib/domain/`
- [ ] No import from `package:flutter`, `package:calorhythm/application`, `package:calorhythm/infrastructure`, `package:calorhythm/presentation`, or `package:calorhythm/di` was introduced (ignore `.g.dart` files)

**If a check fails:**
1. Attempt to fix the violation — if a forbidden import exists, the depending code belongs in a different layer; move it or introduce a domain interface
2. If the fix succeeds, re-run the checklist from the top
3. If the fix cannot be applied, emit the block below and STOP — do not complete the task

```
[LAYER VIOLATION]
Layer   : domain
Rule    : <rule broken>
File    : <file path>
Detail  : <what was found>
Fix     : <what must change before this task can be completed>
```

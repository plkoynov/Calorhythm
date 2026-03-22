# Domain Layer

## Purpose

The innermost layer. Defines the core business concepts of the application. Has no dependencies on any external framework, database, or Flutter itself.

## What belongs here

- `entities/` — Pure business objects. No serialization, no annotations, no framework imports.
- `repositories/` — Abstract interfaces (contracts) that define what persistence operations the application needs. Defined here because their method signatures are expressed entirely in domain types.

## Rules

- No Flutter imports
- No infrastructure imports
- No application imports
- Entities must be immutable where possible
- Repository interfaces define *what* is needed, never *how* it is done

## What does NOT belong here

- Use cases or orchestration logic → `application/`
- Repository implementations → `infrastructure/persistence/repositories/`
- Any UI or state management code → `presentation/`


# Infrastructure Layer

## Purpose

Implements the repository contracts defined in `domain/`. Knows about databases, external services, and all I/O concerns. Never depended upon directly by `application/` or `presentation/` — only wired in through `di/`.

## What belongs here

- `persistence/` — SQLite database via Drift ORM
  - `models/` — Database table definitions (schema)
  - `datasources/local/` — Database instance and Data Access Objects
  - `repositories/` — Concrete implementations of domain repository interfaces
  - `seed/` — Static data bundled with the app

Future integrations (REST APIs, push notifications, analytics, etc.) are added as siblings to `persistence/` inside `infrastructure/`.

## Rules

- Depends on `domain/` (to implement its interfaces)
- Must NOT be imported directly by `application/` or `presentation/`
- All bindings to domain interfaces happen exclusively in `di/`
- Repository implementations must fully satisfy the contract defined in `domain/repositories/`

## What does NOT belong here

- Business logic → `application/`
- Abstract repository contracts → `domain/repositories/`
- UI or state management → `presentation/`


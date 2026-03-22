# Project Rules

> Auto-generated from `docs/rules/`. Edit source files there, not here.

---

# Architecture Conventions

## Dependency Rule

Dependencies always point inward. Outer layers depend on inner layers, never the reverse.

```
presentation → application → domain ← infrastructure
di → (all layers)
```

## Layer Placement

| What | Layer |
|---|---|
| Business objects | `domain/entities/` |
| Persistence contracts | `domain/repositories/` |
| Orchestration logic | `application/usecases/` |
| Shared business utilities | `application/services/` |
| DB / external integrations | `infrastructure/` |
| UI, widgets, state | `presentation/` |
| DI wiring | `di/` |

---

# Coding Conventions

## General

- **One primary class per file.** Small tightly-coupled types (result types, enums, typedefs) may coexist in the same file only if they have no meaning outside it.
- **Absolute imports only.** Always use `package:calorhythm/...`. Never use relative imports (e.g. `../foo.dart`).

## Generated Files

Files ending in `.g.dart` are produced by code generators (Riverpod, Drift, json_serializable). They are exempt from all coding conventions:

- Do **not** manually edit them
- Do **not** apply the absolute imports rule to them
- Do **not** flag them as violations during self-validation
- Regenerate them with `dart run build_runner build --delete-conflicting-outputs`

---

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


---

# Application Layer

## Purpose

Orchestrates business logic. Coordinates domain entities and repository interfaces to fulfil user intents. Has no knowledge of UI, Flutter, or how data is stored.

## What belongs here

- `usecases/` — One use case per user action or business operation. Each use case has a single, clearly named responsibility.
- `services/` — Reusable business logic shared across multiple use cases (e.g. calorie calculation).

## Rules

- Depends only on `domain/`
- No Flutter imports
- No infrastructure imports
- No UI or state management code
- Use cases must be independently testable with mocked repositories

## What does NOT belong here

- Business objects → `domain/entities/`
- Repository contracts → `domain/repositories/`
- Repository implementations → `infrastructure/`
- UI, widgets, providers → `presentation/`


---

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


---

# Presentation Layer

## Purpose

Everything the user sees and interacts with. Translates application state into UI and user interactions into application calls. Uses Flutter and Riverpod.

## What belongs here

- `features/` — Feature modules. Each feature contains:
  - `screens/` — Full-page UI widgets
  - `widgets/` — UI components scoped to the feature
  - `providers/` — Riverpod providers acting as view models (state + interaction logic)
- `router/` — App navigation (go_router)
- `constants/` — UI-specific constants (colors, strings)
- `extensions/` — Display formatting extensions (DateTime, Duration, etc.)
- `theme/` — Material theme configuration

## Rules

- Depends on `application/` and `domain/`
- Must NOT import from `infrastructure/` directly — use providers from `di/`
- Providers (view models) call use cases, never repository implementations
- No business logic in widgets or screens — delegate to providers and use cases
- **One widget per file.** Every widget (screen or component) lives in its own file, regardless of whether it is used only in one parent. Exceptions:
  - A `StatefulWidget` and its `State` subclass may coexist in the same file.
  - A `CustomPainter` (or similar render-only companion) may coexist in the same file as the widget that exclusively owns it.

## What does NOT belong here

- Business logic → `application/`
- Business objects → `domain/entities/`
- DI wiring → `di/`


---

# Dependency Injection Layer

## Purpose

The composition root. The only place in the codebase that knows about all layers simultaneously. Wires infrastructure implementations to domain interfaces and makes them available to the presentation layer via Riverpod providers.

## What belongs here

- Riverpod providers that instantiate infrastructure (e.g. database)
- Riverpod providers that bind domain repository interfaces to their infrastructure implementations
- Lifecycle management (e.g. closing database on dispose)

## Rules

- May depend on all layers
- No business logic
- No UI code
- Keep it thin — only wiring, nothing else
- One place to change when swapping an infrastructure implementation

## What does NOT belong here

- Any logic beyond instantiation and binding → belongs in the appropriate layer


---

# Code Review Guidelines

## Scope

Focus only on:

- Architecture violations (wrong layer placement, dependency rule violations)
- Logic correctness
- Missing tests for use cases

## What to ignore

- Formatting and style — enforced by `dart format` and `flutter analyze` in CI
- Generated files (`*.g.dart`) — do not flag any issues in these files

## PR Scope

Flag if a PR mixes unrelated concerns (e.g. a feature change bundled with an unrelated refactor).

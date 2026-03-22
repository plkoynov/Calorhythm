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


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


# Calorhythm

A simple, offline-first fitness tracking app for home workouts. Track exercises with a timer, calculate calories burned using MET values, and review your workout history.

## Features

- **Exercise Timer** – Start/stop timer per exercise session
- **Calorie Calculation** – Based on MET value, user weight, and duration
- **Rep Multiplier** – Optional adjustment based on repetitions performed
- **Workout History** – Full log of past sessions with duration and calories
- **Statistics** – Daily, weekly, and monthly activity overview
- **User Profile** – Weight and height for accurate calorie tracking

## Architecture

This project follows **Clean Architecture** with strict separation between layers. Dependencies always point inward — outer layers depend on inner layers, never the reverse.

```
presentation → application → domain ← infrastructure
di → (all layers)
```

### Layers

#### `domain/`
The innermost layer. Contains pure business concepts with no external dependencies — no Flutter, no database, no framework.

- `entities/` — Core business objects that represent the problem domain
- `repositories/` — Abstract contracts (interfaces) that define what persistence operations the application needs. Implemented by `infrastructure/`, consumed by `application/`.

#### `application/`
Orchestrates business logic. Depends only on `domain/`. No Flutter or infrastructure dependencies.

- `usecases/` — Application-level operations that coordinate entities and repositories to fulfil a specific user intent
- `services/` — Reusable application logic used across use cases

#### `infrastructure/`
Implements the contracts defined in `domain/repositories/`. Knows about databases, external services, and other I/O concerns. Depends on `domain/` but is not depended upon by `application/` or `presentation/`.

- `persistence/` — SQLite database via Drift ORM
  - `models/` — Database table definitions (schema)
  - `datasources/local/` — Database instance and Data Access Objects
  - `repositories/` — Concrete repository implementations
  - `seed/` — Static seed data bundled with the app

Future integrations (REST APIs, push notifications, analytics, etc.) would be added as siblings to `persistence/` inside `infrastructure/`.

#### `presentation/`
Everything the user sees and interacts with. Depends on `application/` and `domain/`. Uses Flutter and Riverpod.

- `features/` — Feature modules, each containing:
  - `screens/` — Full-page UI widgets
  - `widgets/` — Reusable UI components scoped to the feature
  - `providers/` — Riverpod state management (view models)
- `router/` — App navigation using go_router
- `constants/` — UI constants (colors, strings)
- `extensions/` — Display formatting extensions
- `theme/` — Material theme configuration

#### `di/`
Composition root. Wires all layers together using Riverpod providers — creates infrastructure instances and binds repository interfaces to their concrete implementations.

### Folder Structure

```
src/lib/
├── domain/
│   ├── entities/
│   └── repositories/
├── application/
│   ├── usecases/
│   └── services/
├── infrastructure/
│   └── persistence/
│       ├── models/
│       ├── datasources/
│       ├── repositories/
│       └── seed/
├── presentation/
│   ├── features/
│   │   └── <feature>/
│   │       ├── providers/
│   │       ├── screens/
│   │       └── widgets/
│   ├── router/
│   ├── constants/
│   ├── extensions/
│   └── theme/
├── di/
└── main.dart
```

### Key Technology Choices

| Concern          | Package                                               |
| ---------------- | ----------------------------------------------------- |
| State management | [Riverpod](https://riverpod.dev)                      |
| Navigation       | [go_router](https://pub.dev/packages/go_router)       |
| Local database   | [Drift](https://drift.simonbinder.eu) (SQLite)        |
| Fonts            | [google_fonts](https://pub.dev/packages/google_fonts) |

## Repository Structure

```
/
├── src/            # Flutter project (run all flutter commands from here)
├── docs/           # PRDs and architectural specifications
├── resources/      # Source assets (app icons for Android and iOS)
└── README.md
```

## Getting Started

### Prerequisites

- Flutter SDK `>=3.3.0`
- Dart SDK `>=3.3.0`

### Setup

```bash
cd src

# Install dependencies
flutter pub get

# Run code generation (Drift + Riverpod)
dart run build_runner build --delete-conflicting-outputs

# Run the app
flutter run
```

### Running Tests

```bash
cd src
flutter test
```

## License

MIT

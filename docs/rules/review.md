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

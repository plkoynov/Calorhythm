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


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

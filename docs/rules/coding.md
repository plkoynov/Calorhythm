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

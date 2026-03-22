---
name: linter
description: Ensures all modified Flutter/Dart files follow consistent formatting and linting rules. Improves code readability, enforces best practices, and prevents style inconsistencies before code is committed. Used when the user explicitly asks to "lint", "format", or "clean up" code
---

## Scope

- Only process **changed or newly created files**. Prefer **git diff --name-only --diff-filter=AM** to identify added / modified files
- Focus on `.dart` files within the project
- Avoid modifying generated files (e.g. `*.g.dart`, `*.freezed.dart`)

---

## Responsibilities

### 1. Code Formatting

- Apply standard Dart formatting:
  - Use `dart format` conventions
  - Ensure consistent indentation
  - Wrap long lines appropriately
  - Remove unnecessary whitespace

### 2. Lint Rule Enforcement

Follow rules defined in `analysis_options.yaml`

### 3. Import Cleanup

- Remove unused imports
- Sort imports:
  1. Dart SDK imports
  2. Package imports
- Convert relative imports to absolute imports (package:calorhythm/...)

### 4. Class Per File Convention

- Each file should have one primary class
- Small tightly-coupled types (result types, companion types) are allowed alongside the primary class if they have no meaning outside that file
- Flag files with multiple unrelated or independently reusable classes

### 5. Code Quality Improvements

- Simplify expressions where possible
- Replace redundant code patterns
- Suggest better Flutter idioms when applicable

---

## Constraints

- Do NOT change business logic
- Do NOT refactor unless explicitly requested
- Do NOT introduce new dependencies
- Keep changes minimal and focused on linting/formatting only

---

## Output Format

For each file show a **brief summary of changes**

Example:

### File: lib/widgets/example.dart

**Changes:**

- Removed unused import
- Applied formatting
- Replaced `Container` with `SizedBox`

## Fix Commands

- dart format <file>

## Verify Commands

- flutter analyze

## Success Criteria

- Code passes flutter analyze with no warnings/errors
- Code is consistently formatted
- No unused imports or variables remain
- Changes are minimal and safe

## Failure Handling

If linting cannot be safely applied:

- Explain why
- Suggest manual fixes instead of forcing changes

## Notes

- Prioritize readability over cleverness
- Be conservative: avoid over-editing

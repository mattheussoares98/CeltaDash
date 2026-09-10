---
trigger: model_decision
description: Activate when writing, modifying, or reviewing tests, mocks, test factories, or optimizing performance.
---

## Test Coverage & Mocking
- Every `datasource`, `repository`, and `controller` must have a mirroring test in `test/` covering all public methods, edge cases, and errors.
- Mocking: Use `mocktail`. Explicitly match arguments in `verify`/`expect` (`any()` and `any(named:)` are **forbidden**).

## Test Data
- Use `EntityFactory` pattern (never call constructors directly in tests).
- Nullify properties via annulment flags on `copyWith` (e.g., `annulPropertyName: true`).
- If missing, create a `make` method (e.g., `newEntity`).
- Generate model/JSON test data via `fromEntity` or `toJson` on factory entities.
- Use `faker` only in tests. For Brazilian formats (CPF, CNPJ, phone), use valid static strings, never random faker output.

## Performance
- Minimize widget rebuilds, memory allocation, and time complexity.
- Briefly note performance improvements made. Avoid filler text.

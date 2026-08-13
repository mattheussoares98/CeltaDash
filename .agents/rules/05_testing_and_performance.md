---
trigger: model_decision
description: Activate this rule whenever the user asks to write, modify, or review unit tests, integration tests, or mock data. Also activate when the user specifically asks for performance improvements or refactoring
---

## Test Coverage
- Every `datasource`, `repository`, and `controller` must have a test file mirroring its path in `test/`.
- Every public method in those classes must have a dedicated, named test covering its logic, edge cases, and failure modes.

## Mocking (mocktail)
- Use `mocktail` for all mocks.
- When using `verify` or `expect`, always match arguments explicitly. `any()` and `any(named:)` are **forbidden**.

## Test Data
- Use the `EntityFactory` pattern. Never call class constructors directly in tests (breaks when new properties are added).
- To nullify a property, add an annulment flag to `copyWith` (e.g., `annulPropertyName: true`) and call it on the factory instance.
- If an entity factory doesn't exist, create a `make` method (e.g., `newEntity`) and use it.
- To produce model/JSON test data: generate the entity via factory → convert with `fromEntity` or `toJson`.
- Use `faker` only in test code. For Brazilian formats (CPF, CNPJ, phone), use explicit valid strings — never raw faker randomization.

## Performance
- Every code suggestion must consider widget rebuilds, memory allocation, and time complexity.
- Briefly comment on any performance improvement made.
- No filler output ("here is the code", "ending snippet", etc.).

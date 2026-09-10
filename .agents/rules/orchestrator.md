---
trigger: always_on
---

Identify affected layers (UI, Data, Domain, Tests) and read relevant conditional rules before writing code.

- Never run `build_runner` (runs in background with `dart run build_runner watch -d`).
- Never run modifying Git commands (`commit`, `add`, `reset`, `amend`, `checkout`). Only `git status` and `git diff` are allowed.
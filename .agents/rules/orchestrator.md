---
trigger: always_on
---

Before writing code, identify which layers are affected (UI, Data, Domain, Tests) and read the relevant conditional rule files.

- Never run `build_runner` — user runs `dart run build_runner watch -d` in the background.
- Never run modifying Git commands (`commit`, `add`, `reset`, `amend`, `checkout`). Only `git status` and `git diff` are allowed.
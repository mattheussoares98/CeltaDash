# CeltaDash Architecture Migration: Feature-First & Riverpod

## Overview & Architecture Principles

This documentation guides the step-by-step migration of `celta_dash` from the legacy Clean Architecture + GetX structure to the **Feature-First + Clean Architecture + Riverpod** pattern (aligned with `CeltaMobile`).

### Core Rules & Architectural Shifts
1. **Feature-First**: Everything belonging to a specific domain context is encapsulated inside `lib/features/[feature_name]/`.
2. **No UseCases**: Controllers call Repositories directly. UseCases add unnecessary boilerplate and indirection when logic is straightforward.
3. **No ViewModels / No GetX Presenters**: Eliminate GetX reactive variables (`Rx`, `Obx`, `GetxController`). Use code-generated Riverpod `@riverpod` AsyncNotifier/Notifier controllers.
4. **No UI State in Domain**: Domain entities are pure Dart objects without Flutter or HTTP dependencies.
5. **Strict Imports & Barrel Files**:
   - Every folder must have a barrel file named after the folder (e.g., `entities.dart`, `models.dart`).
   - No relative imports (`../`). Always use absolute package imports: `package:celta_dash/features/...`.
6. **No Modifying Git Commands & No build_runner**:
   - Do not run `build_runner` manually (handled in background via `watch -d`).
   - Only `git status` and `git diff` are permitted.
7. **Continuous Documentation Updates (Living Docs)**:
   - Whenever a missing edge case, missing convention, or pattern is identified during migration, immediately update the relevant document inside `docs/` to keep documentation accurate and prevent repeating mistakes.

---

## Target Feature Folder Structure

```
lib/features/[feature_name]/
├── data/
│   ├── datasource/
│   │   ├── i_[feature]_datasource.dart
│   │   ├── [feature]_datasource.dart       # No _impl in datasource filename
│   │   └── datasource.dart                 # Barrel file
│   ├── models/
│   │   ├── [model_name]_model.dart
│   │   └── models.dart                     # Barrel file
│   └── data.dart                           # Barrel file
├── domain/
│   ├── entities/
│   │   ├── [entity_name]_entity.dart
│   │   └── entities.dart                   # Barrel file
│   ├── repository/
│   │   ├── i_[feature]_repository.dart
│   │   ├── [feature]_repository_impl.dart
│   │   └── repository.dart                 # Barrel file
│   └── domain.dart                         # Barrel file
├── presentation/
│   ├── controllers/
│   │   ├── [feature]_controller.dart
│   │   └── controllers.dart                # Barrel file
│   ├── models/                             # UI state models (if needed)
│   │   └── models.dart
│   ├── pages/
│   │   ├── components/                     # Extracted subwidgets (>100 lines)
│   │   │   └── components.dart
│   │   ├── [feature]_page.dart
│   │   └── pages.dart                      # Barrel file
│   └── presentation.dart                   # Barrel file
├── providers.dart                          # DI with @riverpod
├── providers.g.dart                        # Generated
└── [feature_name].dart                     # Main feature barrel file
```

---

## Migration Guides & Checklists

1. [01. Entity & Model Migration Guide](01_entity_and_model_migration.md)
2. [02. Datasource Migration Guide](02_datasource_migration.md)
3. [03. Repository Migration Guide](03_repository_migration.md)
4. [04. Controller & Presentation Migration Guide](04_controller_and_presentation_migration.md)
5. [05. Providers & Barrel Files Migration Guide](05_providers_and_barrels_migration.md)
6. [06. Unit Testing Guidelines](06_unit_testing_guidelines.md)
7. [07. Navigation & GoRouter Guidelines (Replacing GetX Navigation)](07_navigation_and_gorouter_guidelines.md)
8. [Master Feature Migration Checklist Template](feature_migration_checklist.md)

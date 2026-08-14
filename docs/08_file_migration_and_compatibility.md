# 08. File Migration, Legacy Folders & Backward Compatibility Strategy

## 1. Legacy Folders Status: DO NOT USE FOR NEW CODE

The following root directories belong to the **old architecture** and are actively being phased out:
- `lib/data/`
- `lib/domain/`
- `lib/ui/`
- `lib/presentation/`

> [!IMPORTANT]
> **These folders are obsolete for new code.**
> - **DO NOT** create any new files, entities, models, datasources, or widgets inside `lib/data`, `lib/domain`, `lib/ui`, or `lib/presentation`.
> - **DO NOT** import from these folders when implementing new features.
> - **Reference Only**: Treat existing files in these folders solely as informational references to understand legacy business rules and behavior that need to be migrated.
> - **Shared/Global Domain & Infrastructure**: Any shared cross-feature models or entities (e.g. `FirebaseEnterpriseModel`, `FirebaseEnterpriseEntity`, `EcParams`) must reside in `lib/core/` (e.g. `lib/core/domain/` or `lib/core/data/`), while feature-specific objects belong in `lib/features/[feature_name]/`.

---

## 2. Rule: Move & Forward-Export (Shim Pattern)

When moving or refactoring an existing file from the legacy folders to the new Clean Architecture / Feature-First structure:

1. **Move File**: Move the implementation to its correct new location (`lib/core/` or `lib/features/[feature]/`).
2. **Backward-Compatible Export (Shim)**: In the original legacy location, replace the old file content with an export pointing to the new location (or export via barrel):
   ```dart
   // Legacy location: lib/domain/entities/firebase_enterprise_entity.dart
   export 'package:celta_dash/core/domain/entities/firebase_enterprise_entity.dart';
   ```
3. **Prevent Breakages**: This ensures that legacy presenters and unmigrated parts of the app continue to compile until their respective features are migrated.

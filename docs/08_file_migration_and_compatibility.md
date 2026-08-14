# File Migration & Backward Compatibility Strategy

When moving or refactoring a file from the legacy architecture to the new Clean Architecture / Feature-First folder structure, follow this rule:

## Rule: Move & Forward-Export (Shim Pattern)

1. **Move File**: Move the file / implementation to its correct new location according to Clean Architecture / Feature-First rules.
2. **Backward-Compatible Export (Shim)**: In the original (legacy) location, replace the old file content with an export of the new file location (or export via barrel).
   - This prevents breaking existing legacy code, presenters, and unmigrated features during incremental migration.
   - Example:
     ```dart
     // Legacy location: lib/domain/entities/my_entity.dart
     export 'package:celta_dash/features/my_feature/domain/entities/my_entity.dart';
     ```
3. **Deprecation (Optional / Incremental)**: Unmigrated callers can continue to import the old path or barrel without compilation breaks until their respective feature is migrated.

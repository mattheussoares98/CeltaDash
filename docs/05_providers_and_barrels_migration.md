# 05. Providers & Barrel Files Migration Guide

## Objective
Establish clean dependency injection via `@riverpod` annotations in `providers.dart` and enforce strict barrel file exports and absolute package imports across the entire feature.

---

## 1. Feature Dependency Injection (`providers.dart`)
- **Location**: `lib/features/[feature]/providers.dart`
- **Rules**:
  - Contains `@riverpod` provider functions for Datasource and Repository.
  - Wires HTTP/Core providers into Datasources, and Datasources into Repositories.
  - Automatically generates `providers.g.dart` (managed by the background `build_runner watch`).

### Example
```dart
// lib/features/seller/providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/features/seller/data/datasource/datasource.dart';
import 'package:celta_dash/features/seller/domain/repository/repository.dart';

part 'providers.g.dart';

@riverpod
ISellerDatasource sellerDatasource(Ref ref) {
  final httpClient = ref.watch(httpClientProvider);
  return SellerDatasourceImpl(httpClient);
}

@riverpod
ISellerRepository sellerRepository(Ref ref) {
  final datasource = ref.watch(sellerDatasourceProvider);
  return SellerRepositoryImpl(datasource);
}
```

---

## 2. Barrel Files Conventions
Every subfolder inside the feature must contain a barrel file named after the folder:

| Folder | Barrel File | Exports |
|---|---|---|
| `data/datasource/` | `datasource.dart` | `i_[feature]_datasource.dart`, `[feature]_datasource_impl.dart` |
| `data/models/` | `models.dart` | All `*_model.dart` files |
| `data/` | `data.dart` | `datasource/datasource.dart`, `models/models.dart` |
| `domain/entities/` | `entities.dart` | All `*_entity.dart` files |
| `domain/repository/` | `repository.dart` | `i_[feature]_repository.dart`, `[feature]_repository_impl.dart` |
| `domain/` | `domain.dart` | `entities/entities.dart`, `repository/repository.dart` |
| `presentation/controllers/` | `controllers.dart` | All `*_controller.dart` files |
| `presentation/pages/components/` | `components.dart` | Extracted page components |
| `presentation/pages/` | `pages.dart` | All `*_page.dart` files, `components/components.dart` |
| `presentation/` | `presentation.dart` | `controllers/controllers.dart`, `pages/pages.dart` |
| `features/[feature]/` | `[feature].dart` | `domain/domain.dart`, `presentation/presentation.dart`, `providers.dart` |

---

## 3. Strict Import Rules
- **No relative imports**: Never write `import '../../domain/entities/seller_entity.dart';`
- **Always import the barrel file**:
  - ✅ `import 'package:celta_dash/features/seller/domain/entities/entities.dart';`
  - ❌ `import 'package:celta_dash/features/seller/domain/entities/seller_entity.dart';`
- **Feature-to-Feature encapsulation**: Features should only import public contracts (domain/presentation/providers) from other features, never internal datasource or model implementations.

---

## Checklist for Providers & Barrels
- [ ] Create `lib/features/[feature]/providers.dart` declaring datasource and repository providers.
- [ ] Ensure all subdirectories have matching barrel files (`datasource.dart`, `models.dart`, `entities.dart`, `repository.dart`, `controllers.dart`, `pages.dart`, `components.dart`).
- [ ] Ensure layer barrel files exist (`data.dart`, `domain.dart`, `presentation.dart`).
- [ ] Create root feature barrel file `[feature].dart`.
- [ ] Verify that all imports across the feature use absolute package paths and barrel references.

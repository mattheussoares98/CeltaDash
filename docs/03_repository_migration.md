# 03. Repository Migration Guide

## Objective
The Repository acts as the single source of truth for the domain layer. It translates data models into pure domain entities and abstracts datasource details away from presentation controllers.

*(Note: We do not use UseCases in this project. The Repository is injected directly into Riverpod Controllers).*

---

## 1. Repository Interface (`domain/repository/i_[feature]_repository.dart`)
- **Location**: `lib/features/[feature]/domain/repository/i_[feature]_repository.dart`
- **Rules**:
  - Exposes business-oriented contracts returning domain entities.
  - Return types use pure entities (e.g. `Future<List<SellerEntity>>`).
  - Interface lives in the `domain` layer.

### Example
```dart
// lib/features/seller/domain/repository/i_seller_repository.dart
import 'package:celta_dash/features/seller/domain/entities/entities.dart';

abstract class ISellerRepository {
  Future<List<SellerEntity>> getSellers({
    required DateTime startDate,
    required DateTime endDate,
    int? companyId,
  });
}
```

---

## 2. Repository Implementation (`data/repository/[feature]_repository_impl.dart`)
- **Location**: `lib/features/[feature]/data/repository/[feature]_repository_impl.dart`
- **Rules**:
  - Lives in the **Data Layer** (implements the Domain repository interface).
  - Injects `I[Feature]Datasource`.
  - Calls datasource methods and maps Models to Entities using `.toEntity()`.
  - Performs any domain validation, data aggregation, or sorting before returning.
  - Handles or propagates domain-specific failures.

### Example
```dart
// lib/features/seller/data/repository/seller_repository_impl.dart
import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/features/seller/data/datasource/datasource.dart';
import 'package:celta_dash/features/seller/domain/entities/entities.dart';
import 'package:celta_dash/features/seller/domain/repository/repository.dart';

class SellerRepositoryImpl implements ISellerRepository {
  final ISellerDatasource _datasource;

  const SellerRepositoryImpl(this._datasource);

  @override
  Future<List<SellerEntity>> getSellers({
    required GetSellerParams params,
    required EcParams ecParams,
  }) async {
    final models = await _datasource.getSellers(
      params: params,
      ecParams: ecParams,
    );

    return models.map((model) => model.toEntity()).toList();
  }
}
```

---

## Checklist for Repositories
- [ ] Create `domain/repository/i_[feature]_repository.dart` interface returning Entities.
- [ ] Create `domain/repository/[feature]_repository_impl.dart` implementing the interface.
- [ ] Inject `I[Feature]Datasource` via constructor.
- [ ] Map model list/items to entities (`models.map((m) => m.toEntity()).toList()`).
- [ ] Create `domain/repository/repository.dart` barrel file exporting interface and implementation.
- [ ] Ensure the repository has NO HTTP/API-specific dependencies (only datasource contract).
- [ ] Write unit tests for the repository implementation mocking the datasource.

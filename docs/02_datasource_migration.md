# 02. Datasource Migration Guide

## Objective
Encapsulate all external I/O (REST API, local storage, etc.) inside feature-specific datasources using interface-driven development (`i_[feature]_datasource.dart` and `[feature]_datasource_impl.dart`).

---

## 1. Interface Definition (`i_[feature]_datasource.dart`)
- **Location**: `lib/features/[feature]/data/datasource/i_[feature]_datasource.dart`
- **Rules**:
  - Defines the exact contracts and parameters required for network or local requests.
  - Returns raw DTO models or primitive collections (e.g. `Future<List<SellerModel>>`).
  - No Flutter imports.

### Example
```dart
// lib/features/seller/data/datasource/i_seller_datasource.dart
import 'package:celta_dash/features/seller/data/models/models.dart';

abstract class ISellerDatasource {
  Future<List<SellerModel>> getSellers({
    required DateTime startDate,
    required DateTime endDate,
    int? companyId,
  });
}
```

---

## 2. Implementation (`[feature]_datasource.dart`)
- **Location**: `lib/features/[feature]/data/datasource/[feature]_datasource.dart` *(Note: Do NOT use `_impl` suffix for datasource files)*.
- **Rules**:
  - Implements `I[Feature]Datasource`.
  - Injects `HttpClient` via constructor.
  - Receives `EcParams` and parameters object calling `params.toBody()` and `ecParams.toHeaders()`.
  - **Never import or use global static objects like `EnterpriseBuilder`**. All endpoint credentials must be passed explicitly via `EcParams`.
  - Handles endpoint paths, query parameters, headers, and payload serialization.
  - Converts HTTP JSON responses into Models.
  - Throws custom app exceptions or domain errors on failures.

### Example
```dart
// lib/features/seller/data/datasource/seller_datasource.dart
import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/data/http/http.dart';
import 'package:celta_dash/data/mixins/mixins.dart';
import 'package:celta_dash/features/seller/data/datasource/i_seller_datasource.dart';
import 'package:celta_dash/features/seller/data/models/models.dart';

class SellerDatasource  implements ISellerDatasource {
  final HttpClient _httpClient;

  const SellerDatasource(this._httpClient);

  @override
  Future<List<SellerModel>> getSellers({
    required GetSellerParams params,
    required EcParams ecParams,
  }) async {
    try {
      final response = await _httpClient.request(
        url: '${ecParams.url}/api/v1/sellers',
        method: 'post',
        headers: ecParams.toHeaders(),
        body: params.toBody(),
      );

      final List<dynamic> data = response['results'] ?? [];
      return data.map((json) => SellerModel.fromJson(json as Map)).toList();
    } catch (e) {
      treatError(e);
    }
  }
}
```

---

## Checklist for Datasources
- [ ] Create `i_[feature]_datasource.dart` with clear method signatures.
- [ ] Create `[feature]_datasource_impl.dart` injecting HTTP / Client abstraction.
- [ ] Ensure all exceptions are properly caught and mapped to standard custom domain/core exceptions.
- [ ] Create `data/datasource/datasource.dart` barrel file exporting interface and implementation.
- [ ] Verify no UI or Flutter framework dependencies are used in datasources.
- [ ] Write unit tests for the datasource implementation mocking the HTTP client.

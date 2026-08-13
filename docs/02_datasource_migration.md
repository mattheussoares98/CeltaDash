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

## 2. Implementation (`[feature]_datasource_impl.dart`)
- **Location**: `lib/features/[feature]/data/datasource/[feature]_datasource_impl.dart`
- **Rules**:
  - Implements `I[Feature]Datasource`.
  - Injects `IHttpClient` (or relevant network client) via constructor.
  - Handles endpoint paths, query parameters, headers, and payload serialization.
  - Converts HTTP JSON responses into Models.
  - Throws custom app exceptions (e.g. `ServerException`, `UnauthorizedException`) on failures.

### Example
```dart
// lib/features/seller/data/datasource/seller_datasource_impl.dart
import 'package:celta_dash/core/services/http_client/http_client.dart';
import 'package:celta_dash/exceptions/exceptions.dart';
import 'package:celta_dash/features/seller/data/datasource/i_seller_datasource.dart';
import 'package:celta_dash/features/seller/data/models/models.dart';

class SellerDatasourceImpl implements ISellerDatasource {
  final IHttpClient _httpClient;

  const SellerDatasourceImpl(this._httpClient);

  @override
  Future<List<SellerModel>> getSellers({
    required DateTime startDate,
    required DateTime endDate,
    int? companyId,
  }) async {
    try {
      final response = await _httpClient.get(
        url: '/api/v1/sellers',
        queryParameters: {
          'start_date': startDate.toIso8601String(),
          'end_date': endDate.toIso8601String(),
          if (companyId != null) 'company_id': companyId.toString(),
        },
      );

      final List<dynamic> data = response.data;
      return data.map((json) => SellerModel.fromJson(json as Map<String, dynamic>)).toList();
    } on AppException {
      rethrow;
    } catch (e, stack) {
      throw ServerException(
        message: 'Failed to fetch sellers: $e',
        stackTrace: stack,
      );
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

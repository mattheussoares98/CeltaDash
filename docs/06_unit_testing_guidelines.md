# 06. Unit Testing Guidelines

## Objective
Ensure 100% test coverage for all **Datasources**, **Repositories**, and **Riverpod Controllers** using `mocktail` and `flutter_test`.

---

## 1. Directory Structure for Feature Tests
Mirror the feature structure inside the `test/` directory:
```
test/features/[feature]/
├── data/
│   ├── datasource/
│   │   └── [feature]_datasource_impl_test.dart
│   └── models/
│       └── [model]_model_test.dart
├── domain/
│   └── repository/
│       └── [feature]_repository_impl_test.dart
└── presentation/
    └── controllers/
        └── [feature]_controller_test.dart
```

---

## 2. Datasource Testing
- **Goal**: Verify HTTP requests (URL, method, query parameters, body, headers) and JSON to Model serialization or exception throwing on failure.
- **Dependencies to Mock**: `IHttpClient`.

### Example
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:celta_dash/core/services/http_client/http_client.dart';
import 'package:celta_dash/exceptions/exceptions.dart';
import 'package:celta_dash/features/seller/data/datasource/datasource.dart';
import 'package:celta_dash/features/seller/data/models/models.dart';

class MockHttpClient extends Mock implements IHttpClient {}

void main() {
  late MockHttpClient mockHttpClient;
  late SellerDatasourceImpl datasource;

  setUp(() {
    mockHttpClient = MockHttpClient();
    datasource = SellerDatasourceImpl(mockHttpClient);
  });

  group('SellerDatasourceImpl', () {
    final tDate = DateTime(2026, 1, 1);
    final tResponseData = [
      {'id': 1, 'name': 'John Doe', 'total_sales': 500.0}
    ];

    test('should return List<SellerModel> on successful HTTP 200 call', () async {
      when(() => mockHttpClient.get(
            url: any(named: 'url'),
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer((_) async => HttpResponse(data: tResponseData, statusCode: 200));

      final result = await datasource.getSellers(startDate: tDate, endDate: tDate);

      expect(result, isA<List<SellerModel>>());
      expect(result.first.id, 1);
      expect(result.first.name, 'John Doe');
      verify(() => mockHttpClient.get(
            url: '/api/v1/sellers',
            queryParameters: {
              'start_date': tDate.toIso8601String(),
              'end_date': tDate.toIso8601String(),
            },
          )).called(1);
    });

    test('should throw ServerException when HTTP call fails', () async {
      when(() => mockHttpClient.get(
            url: any(named: 'url'),
            queryParameters: any(named: 'queryParameters'),
          )).thenThrow(const ServerException(message: 'Server error'));

      expect(
        () => datasource.getSellers(startDate: tDate, endDate: tDate),
        throwsA(isA<ServerException>()),
      );
    });
  });
}
```

---

## 3. Repository Testing
- **Goal**: Verify that datasource results are converted to pure domain entities and domain exceptions are handled.
- **Dependencies to Mock**: `ISellerDatasource`.

### Example
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:celta_dash/features/seller/data/datasource/datasource.dart';
import 'package:celta_dash/features/seller/data/models/models.dart';
import 'package:celta_dash/features/seller/domain/entities/entities.dart';
import 'package:celta_dash/features/seller/domain/repository/repository.dart';

class MockSellerDatasource extends Mock implements ISellerDatasource {}

void main() {
  late MockSellerDatasource mockDatasource;
  late SellerRepositoryImpl repository;

  setUp(() {
    mockDatasource = MockSellerDatasource();
    repository = SellerRepositoryImpl(mockDatasource);
  });

  group('SellerRepositoryImpl', () {
    final tDate = DateTime(2026, 1, 1);
    const tModels = [
      SellerModel(id: 1, name: 'John Doe', totalSales: 500.0),
    ];

    test('should return List<SellerEntity> when datasource returns models', () async {
      when(() => mockDatasource.getSellers(
            startDate: any(named: 'startDate'),
            endDate: any(named: 'endDate'),
          )).thenAnswer((_) async => tModels);

      final result = await repository.getSellers(startDate: tDate, endDate: tDate);

      expect(result, isA<List<SellerEntity>>());
      expect(result.first.id, 1);
      expect(result.first.name, 'John Doe');
      verify(() => mockDatasource.getSellers(startDate: tDate, endDate: tDate)).called(1);
    });
  });
}
```

---

## 4. Riverpod Controller Testing
- **Goal**: Test initial state loading, `AsyncValue.data`, `AsyncValue.error`, and mutation/action methods using `ProviderContainer`.
- **Dependencies to Mock**: `ISellerRepository`.

### Example
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:celta_dash/features/seller/domain/entities/entities.dart';
import 'package:celta_dash/features/seller/domain/repository/repository.dart';
import 'package:celta_dash/features/seller/presentation/controllers/controllers.dart';
import 'package:celta_dash/features/seller/providers.dart';

class MockSellerRepository extends Mock implements ISellerRepository {}

void main() {
  late MockSellerRepository mockRepository;
  final tDate = DateTime(2026, 1, 1);
  const tEntities = [
    SellerEntity(id: 1, name: 'John Doe', totalSales: 500.0),
  ];

  setUp(() {
    mockRepository = MockSellerRepository();
  });

  ProviderContainer createContainer() {
    final container = ProviderContainer(
      overrides: [
        sellerRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('SellerController', () {
    test('build loads seller entities asynchronously into AsyncData', () async {
      when(() => mockRepository.getSellers(
            startDate: any(named: 'startDate'),
            endDate: any(named: 'endDate'),
          )).thenAnswer((_) async => tEntities);

      final container = createContainer();
      final provider = sellerControllerProvider(startDate: tDate, endDate: tDate);

      // Listen to keep provider alive
      final listener = container.listen(provider, (_, __) {});

      // Initial read triggers build
      expect(container.read(provider), const AsyncValue<List<SellerEntity>>.loading());

      // Wait for future to complete
      final result = await container.read(provider.future);

      expect(result, tEntities);
      expect(container.read(provider).value, tEntities);
    });
  });
}
```

---

## Testing Checklist
- [ ] Create unit tests for each Datasource implementation.
- [ ] Create unit tests for each Repository implementation.
- [ ] Create unit tests for each Riverpod Controller with `ProviderContainer`.
- [ ] Test success cases, empty data cases, and error/exception handling paths.

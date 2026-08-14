# 04. Controller & Presentation Migration Guide

## Objective
Migrate legacy GetX Presenters and ViewModels to **Riverpod AsyncNotifier / Notifier Controllers** using code generation (`@riverpod`). Migrate UI screens to `ConsumerWidget` / `ConsumerStatefulWidget` with fine-grained reactivity.

---

## 1. Riverpod Controller Pattern
- **Location**: `lib/features/[feature]/presentation/controllers/[feature]_controller.dart`
- **Rules**:
  - Use `@riverpod` annotation with code generation (generated file: `[feature]_controller.g.dart` or via `providers.g.dart`).
  - No `GetxController`, no `Rx`, no `Obx`, no separate `ViewModel` classes.
  - Injects `ISellerRepository` from the feature's repository provider.
  - In `build()`, perform the initial async load or initialize default state.
  - Expose mutation methods that update `state = AsyncValue.data(...)` or re-fetch.
  - Export in `presentation/controllers/controllers.dart`.

### Example
```dart
// lib/features/seller/presentation/controllers/seller_controller.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:celta_dash/features/seller/domain/entities/entities.dart';
import 'package:celta_dash/features/seller/providers.dart';

part 'seller_controller.g.dart';

@riverpod
class SellerController extends _$SellerController {
  @override
  FutureOr<List<SellerEntity>> build({
    required DateTime startDate,
    required DateTime endDate,
    int? companyId,
  }) async {
    final repository = ref.watch(sellerRepositoryProvider);
    return repository.getSellers(
      startDate: startDate,
      endDate: endDate,
      companyId: companyId,
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(sellerRepositoryProvider);
      return repository.getSellers(
        startDate: startDate,
        endDate: endDate,
        companyId: companyId,
      );
    });
  }
}
```

---

## 2. Parameterized Controllers (Riverpod Family via Params Objects)
- **When to use**: When the repository method is identical and only the query filters/parameters change (e.g. `getSaleStatistics(GetSaleStatisticsParams params)` for departments, sections, sellers, payment methods).
- **Rules**:
  - Pass the parameters object (e.g. `GetSaleStatisticsParams`) directly as an argument to the controller's `build(GetSaleStatisticsParams params)` method.
  - The parameter class **MUST extend `Equatable`** (or implement `==` and `hashCode`). This guarantees Riverpod correctly identifies and caches distinct controller instances per parameter combination without duplicating controller classes.

### Example (Sale Statistics)
```dart
// lib/features/sale_statistics/presentation/controllers/sale_statistics_controller.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:celta_dash/features/sale_statistics/domain/entities/entities.dart';
import 'package:celta_dash/features/sale_statistics/providers.dart';

part 'sale_statistics_controller.g.dart';

@riverpod
class SaleStatisticsController extends _$SaleStatisticsController {
  @override
  FutureOr<List<SaleStatisticsEntity>> build(GetSaleStatisticsParams params) async {
    final repository = ref.watch(saleStatisticsRepositoryProvider);
    return repository.getSaleStatistics(params);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(saleStatisticsRepositoryProvider);
      return repository.getSaleStatistics(params);
    });
  }
}
```

### Usage in Widgets:
```dart
// In Departments Screen:
final departmentsAsync = ref.watch(
  saleStatisticsControllerProvider(
    GetSaleStatisticsParams(
      startDate: startDate,
      endDate: endDate,
      groupByProductDepartment: true,
    ),
  ),
);

// In Sellers Screen (reuses the same controller class with a distinct cache key):
final sellersAsync = ref.watch(
  saleStatisticsControllerProvider(
    GetSaleStatisticsParams(
      startDate: startDate,
      endDate: endDate,
      groupBySeller: true,
    ),
  ),
);
```

---

## 3. Presentation Pages & Widgets
- **Location**: `lib/features/[feature]/presentation/pages/[feature]_page.dart`
- **Rules**:
  - Prefer `ConsumerWidget` or Riverpod `Consumer` over `StatefulWidget`.
  - Use `.select()` when a widget only needs a specific field from state to prevent unnecessary rebuilds.
  - Never call datasources directly from presentation.
  - Extract sub-widgets to a `components/` subfolder when the page file exceeds ~100 lines.
  - Always use `const` constructors wherever possible.
  - Handle `AsyncValue` states using `state.when(data: ..., loading: ..., error: ...)`.

### Example
```dart
// lib/features/seller/presentation/pages/seller_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/seller/presentation/controllers/controllers.dart';
import 'package:celta_dash/features/seller/presentation/pages/components/components.dart';

class SellerPage extends ConsumerWidget {
  final DateTime startDate;
  final DateTime endDate;
  final int? companyId;

  const SellerPage({
    super.key,
    required this.startDate,
    required this.endDate,
    this.companyId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sellersAsync = ref.watch(
      sellerControllerProvider(
        startDate: startDate,
        endDate: endDate,
        companyId: companyId,
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Sellers')),
      body: sellersAsync.when(
        data: (sellers) => SellerListView(sellers: sellers),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
```

---

## 5. Strict Theme-Driven UI (Dark & Light Mode Support)
Because the application supports dynamic switching between **Dark Mode** and **Light Mode**, all UI components and pages must strictly adhere to theme styling:
- **Colors**: Access colors via `Theme.of(context).colorScheme` (e.g., `primary`, `onSurface`, `surfaceContainer`, `error`) or theme properties (`scaffoldBackgroundColor`, `dividerColor`).
- **Forbidden**: Never hardcode colors (`Colors.white`, `Colors.black`, `Colors.grey[800]`, `#1E1E1E`).
- **Typography**: Always use `Theme.of(context).textTheme` styles (e.g., `titleMedium`, `bodyMedium`, `labelSmall`).
- **Opacity**: Use `.withAlpha(0–255)` instead of `.withOpacity(...)` to avoid performance penalties.

---

## Checklist for Controller & Presentation
- [ ] Remove legacy GetX Presenter and ViewModels for the feature.
- [ ] Create `@riverpod` controller extending `_$[Feature]Controller`.
- [ ] Implement `build(...)` method returning state or `FutureOr<State>`.
- [ ] Add mutation/action methods in the controller using `state = AsyncData(...)` or `AsyncValue.guard`.
- [ ] Convert UI page to `ConsumerWidget`.
- [ ] Replace `Obx` / `GetBuilder` / `GetX` with `ref.watch(provider)`.
- [ ] Extract subwidgets to `components/` subfolder if file exceeds ~100 lines.
- [ ] Ensure `presentation/controllers/controllers.dart` and `presentation/pages/pages.dart` barrel files exist.
- [ ] Ensure all UI components and text styles use `Theme.of(context)` (no hardcoded colors/styles).
- [ ] Write unit tests for Riverpod controllers using `ProviderContainer` to verify async loading, data states, and mutations.

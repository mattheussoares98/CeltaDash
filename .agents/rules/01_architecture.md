---
trigger: always_on
---

Feature-First + Clean Architecture. Never invent new patterns.

## Folder Structure
```
lib/
├── commom_widgets/   # Generic reusable widgets
├── constants/        # Global constants
├── core/             # Shared infra (data/domain/presentation)
├── exceptions/       # Custom exceptions
├── features/         # Bounded contexts
├── localization/     # i18n
├── routing/          # go_router config
└── utils/            # Helpers and formatters
```

## Feature Internal Structure
```
[feature]/
├── data/
│   ├── datasource/   # i_*.dart interfaces + implementations
│   └── models/       # DTOs
├── domain/
│   ├── entities/     # Pure Dart business objects
│   └── repository/   # i_*.dart interfaces + *_impl.dart
├── presentation/
│   ├── controllers/  # Riverpod state controllers
│   ├── models/       # UI-specific state models
│   └── pages/        # Widgets and screens
├── providers.dart
└── providers.g.dart
```

## Layer Rules
- **Domain**: pure Dart only — no Flutter, no HTTP, no Hive.
- **Data**: implements domain interfaces; handles all external I/O.
- **Presentation**: depends on domain only; never touches datasources directly.

## Riverpod
- Use `@riverpod` with code generation for all providers.
- Use `.select()` when a widget only needs one property from a state.
- Use `Consumer` to scope rebuilds instead of watching inside `build`.
- Call `ref.invalidate` only if data is loaded inside the provider's `build`.

### DI Pattern (providers.dart)
```dart
@riverpod
IMyDatasource myDatasource(Ref ref) => MyDatasourceImpl(ref.watch(httpClientProvider));

@riverpod
IMyRepository myRepository(Ref ref) => MyRepositoryImpl(ref.watch(myDatasourceProvider));
```

### Controller Pattern
```dart
@riverpod
class MyController extends _$MyController {
  @override
  FutureOr<MyEntity> build({required int id}) async { /* fetch */ }

  void updateField(String v) {
    if (state is! AsyncData<MyEntity>) return;
    state = AsyncData(state.value!.copyWith(field: v));
  }
}
```

## Widgets and Imports
- **No relative imports.** Always use `package:celta_dash/`.
- **Barrel files required** in every major folder (same name as folder). Always import the barrel, never an individual file.
  - ✅ `import 'package:celta_dash/features/auth/domain/entities/entities.dart';`
  - ❌ `import 'package:celta_dash/features/auth/domain/entities/user_entity.dart';`
- **Always specify the full file path** at the top of every code block you provide.
- Pages go in `presentation/pages/`. Extract sub-widgets to a `components/` subfolder when the file exceeds ~100 lines.
- **Never use `StatefulWidget`**: Always use `HookWidget` or `HookConsumerWidget` (`flutter_hooks`) to manage local widget state, controllers, and focus nodes, alongside Riverpod controllers for business state.
- Always use `const` constructors.
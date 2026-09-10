---
trigger: always_on
---

Feature-First + Clean Architecture. Never invent new patterns.

## Structure (`lib/`)
- Root folders: `commom_widgets/`, `constants/`, `core/`, `exceptions/`, `features/`, `localization/`, `routing/`, `utils/`.
- Per feature: `data/` (`datasource/`, `models/`), `domain/` (`entities/`, `repository/`), `presentation/` (`controllers/`, `models/`, `pages/`), `providers.dart`, `providers.g.dart`.

## Layers
- **Domain**: Pure Dart only (no Flutter, HTTP, Hive).
- **Data**: Implements domain interfaces; handles external I/O.
- **Presentation**: Depends on domain only; never touches datasources directly.

## Riverpod
- Use `@riverpod` code generation for all providers.
- Use `.select()` for scoped property reads; use `Consumer` to limit rebuilds.
- `ref.invalidate` only if data is loaded inside provider's `build`.

### DI (`providers.dart`) & Controller
```dart
@riverpod
IMyDatasource myDatasource(Ref ref) => MyDatasourceImpl(ref.watch(httpClientProvider));
@riverpod
IMyRepository myRepository(Ref ref) => MyRepositoryImpl(ref.watch(myDatasourceProvider));

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

## Widgets & Imports
- **No relative imports**: Always use `package:celta_dash/`.
- **Barrel files**: Create only in leaf folders (e.g. `entities/entities.dart`, `models/models.dart`, `controllers/controllers.dart`). Always import the barrel, never individual files.
  - ❌ **FORBIDDEN**: Never create coarse barrel files: `data.dart`, `domain.dart`, `presentation.dart`, or `<feature_name>.dart`.
- **Pages**: In `presentation/pages/`. Extract sub-widgets to `components/` if file > 100 lines.
- **Hooks**: Never use `StatefulWidget`. Use `HookWidget` or `HookConsumerWidget` for local state/controllers/focus nodes.
- Always use `const` constructors.
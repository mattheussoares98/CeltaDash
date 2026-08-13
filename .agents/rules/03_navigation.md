---
trigger: model_decision
description: Activate this rule whenever the user asks to create a new screen, modify the router, handle deep linking, pass data between pages, or display dialogs/bottom sheets
---

## Core
- Router: `go_router` + Riverpod. Config in `lib/routing/app_router.dart`.
- Route names: `Routes` enum in `lib/routing/routes.dart`. Never use raw strings.
- **Forbidden**: `Navigator.push/pop/pushReplacement`. Use `context.pushNamed()`, `context.goNamed()`, `context.pop()`.

## Adding Routes
Each route lives in its own file under `lib/routing/routes/[feature]/`. Pattern:
```dart
RouteBase myFeatureRoute(List<RouteBase> routes) => GoRoute(
  path: 'my-feature',
  name: Routes.myFeature.name,
  builder: (context, state) => const MyFeaturePage(),
  routes: routes,
);
```
Assemble hierarchically in `app_router.dart`.

## Passing Data
- **Simple IDs** → path parameters (`state.pathParameters`).
- **Complex objects** → `state.extra` as `Map<String, dynamic>`:
```dart
// Navigate
context.pushNamed(Routes.x.name, extra: {'product': entity});

// Receive
final extra = state.extra as Map<String, dynamic>;
final product = extra['product'] as ProductEntity;
```

## Dialogs and Bottom Sheets
Not tied to go_router. Use wrappers from `lib/commom_widgets`:
- **Bottom sheets**: `showModalPage(body, context)`
- **Alerts**: `showAlertDialog(...)` / `showExceptionAlertDialog(...)`
- **Dismiss**: `context.pop()`

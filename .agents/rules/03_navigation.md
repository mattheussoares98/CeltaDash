---
trigger: model_decision
description: Activate when creating screens, modifying routes, deep linking, passing navigation data, or opening dialogs/sheets.
---

## Core
- Router: `go_router` + Riverpod in `lib/routing/app_router.dart`.
- Route names: `Routes` enum in `lib/routing/routes.dart` (no raw strings).
- Navigation: Use `context.pushNamed()`, `context.goNamed()`, `context.pop()`. `Navigator.push/pop` is **forbidden**.

## Adding Routes (`lib/routing/routes/[feature]/`)
```dart
RouteBase myFeatureRoute(List<RouteBase> routes) => GoRoute(
  path: 'my-feature',
  name: Routes.myFeature.name,
  builder: (context, state) => const MyFeaturePage(),
  routes: routes,
);
```

## Passing Data
- Simple IDs: `state.pathParameters`.
- Objects: `state.extra` as `Map<String, dynamic>` (`context.pushNamed(Routes.x.name, extra: {'product': entity})`).
- Receive: `(state.extra as Map<String, dynamic>)['product'] as ProductEntity`.

## Dialogs & Sheets (`lib/commom_widgets/`)
- Sheets: `showModalPage(body, context)`. Alerts: `showAlertDialog(...)` / `showExceptionAlertDialog(...)`. Dismiss: `context.pop()`.

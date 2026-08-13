# 07. Navigation & GoRouter Guidelines (Replacing GetX Navigation)

## Objective
Completely eliminate GetX from the project (`Get.toNamed`, `Get.to`, `Get.back`, `Get.snackbar`, `Get.dialog`, `Get.bottomSheet`, `GetMaterialApp`) and replace all navigation with **GoRouter + Riverpod** and standard Flutter / Common Widgets overlays.

---

## 1. App Router Configuration
- **Location**: `lib/routing/app_router.dart`
- **Route Enum**: `lib/routing/routes.dart` (`enum Routes { ... }`).
- **Rules**:
  - Never use raw route strings; always use `Routes.[name].name`.
  - Use `go_router` provider hooked to Riverpod (`ref.watch(goRouterProvider)`).
  - Main app root uses `MaterialApp.router` (or `CupertinoApp.router`), NEVER `GetMaterialApp`.

---

## 2. Route Definitions
Each route is defined in a modular function in `lib/routing/routes/[feature]/`:
```dart
// lib/routing/routes/seller/seller_route.dart
import 'package:go_router/go_router.dart';
import 'package:celta_dash/features/seller/presentation/pages/pages.dart';
import 'package:celta_dash/routing/routes.dart';

RouteBase sellerRoute(List<RouteBase> routes) => GoRoute(
  path: 'sellers',
  name: Routes.sellers.name,
  builder: (context, state) {
    final extra = state.extra as Map<String, dynamic>?;
    return SellerPage(
      startDate: extra?['startDate'] as DateTime,
      endDate: extra?['endDate'] as DateTime,
    );
  },
  routes: routes,
);
```

---

## 3. Navigation Replacements (GetX vs GoRouter)

| Legacy GetX | GoRouter / Modern Flutter Equivalent |
|---|---|
| `Get.toNamed('/sellers')` | `context.pushNamed(Routes.sellers.name)` |
| `Get.offNamed('/home')` | `context.goNamed(Routes.home.name)` |
| `Get.back()` | `context.pop()` |
| `Get.snackbar('Title', 'Msg')` | `ScaffoldMessenger.of(context).showSnackBar(...)` |
| `Get.dialog(MyDialog())` | `showAlertDialog(context: context, ...)` / `showAdaptiveDialog(...)` |
| `Get.bottomSheet(MySheet())` | `showModalPage(context: context, body: ...)` |
| `Get.arguments` | `state.pathParameters` or `state.extra as Map<String, dynamic>` |

---

## 4. Passing Data Between Screens
- **Simple IDs / URL segments**: Use `state.pathParameters`:
  ```dart
  // Route: path: 'seller/:id'
  context.pushNamed(Routes.sellerDetail.name, pathParameters: {'id': '123'});
  ```
- **Complex Objects / Filters**: Use `state.extra` as a typed `Map<String, dynamic>`:
  ```dart
  // Sender:
  context.pushNamed(
    Routes.sellers.name,
    extra: {
      'startDate': startDate,
      'endDate': endDate,
    },
  );

  // Receiver in route builder:
  final extra = state.extra as Map<String, dynamic>;
  final startDate = extra['startDate'] as DateTime;
  final endDate = extra['endDate'] as DateTime;
  ```

---

## Checklist for Navigation Migration
- [ ] Ensure all routes for the feature are added to `lib/routing/routes.dart` enum.
- [ ] Define the modular `RouteBase` in `lib/routing/routes/[feature]/`.
- [ ] Register the route in `lib/routing/app_router.dart`.
- [ ] Replace all `Get.to`, `Get.toNamed`, `Get.offNamed` with `context.pushNamed` or `context.goNamed`.
- [ ] Replace `Get.back()` with `context.pop()`.
- [ ] Replace `Get.snackbar()` with `ScaffoldMessenger` or common alert widgets.
- [ ] Replace `Get.dialog()` and `Get.bottomSheet()` with `showAlertDialog()` and `showModalPage()`.
- [ ] Remove `import 'package:get/get.dart';` from all feature files.

# Home Feature Implementation Plan

## Goal

Create a feature-first `home` shell based on the behavior of the legacy `lib/ui/pages/home/home_page.dart`. The shell will provide route-driven tab navigation, the shared home app bar, the body outlet, and bottom navigation. Resume, sales, products, personalized reports, and more will be migrated as separate pages under the home feature and will reuse `SaleStatisticsController` with page-specific `GetSaleStatisticsParams`.

This plan does not migrate every page at once. Each phase is an independently reviewable slice, and implementation must stop for validation before starting the next phase.

## Architectural Boundaries

- `HomeController` owns only shell state: selected date, selected BS enterprise, enabled status, app mode, and any home initialization state.
- GoRouter owns the selected destination. Do not store a duplicate `currentPageIndex` in Riverpod; derive the bottom-navigation index from the active route.
- `SaleStatisticsController` owns report loading and caching. Each report page supplies its own `CategoryGroupingType` and `GetSaleStatisticsParams`.
- Pages never call datasources. They watch the home state and the appropriate `saleStatisticsControllerProvider(...)` instance.
- The legacy `lib/ui`, `lib/presentation`, `lib/domain/usecases`, and `lib/data/usecases` files are behavioral references only. New code belongs in `lib/features/home`, `lib/core`, and `lib/routing`.
- Do not let GetX and Riverpod own the same migrated page or state. During transition, an unmigrated destination remains wholly legacy until its complete vertical slice is moved.

## Target Structure

```text
lib/features/home/
├── data/
│   ├── datasource/
│   ├── models/
│   ├── repository/
│   └── data.dart
├── domain/
│   ├── entities/
│   ├── repository/
│   └── domain.dart
├── presentation/
│   ├── controllers/
│   ├── models/
│   └── pages/
│       ├── components/
│       ├── home_page.dart
│       ├── resume_page.dart
│       ├── sales_page.dart
│       ├── products_page.dart
│       ├── personalized_page.dart
│       └── more_page.dart
├── providers.dart
└── home.dart

lib/routing/routes/home/
├── home_route.dart
├── home_resume_route.dart
├── home_sales_route.dart
├── home_products_route.dart
├── home_personalized_route.dart
├── home_more_route.dart
└── home.dart
```

Only create the data/domain folders and contracts that are required by the missing capabilities listed below. Do not duplicate `sale_statistics` models, datasource, repository, or controller inside `home`.

## Phase 1 — Route Navigation

1. Add explicit named destinations to `Routes`: `homeResume`, `homeSales`, `homeProducts`, `homePersonalized`, and `homeMore`.
2. Replace the factory-built `/home` page route with a home shell route whose persistent builder renders `HomePage` around the active child.
3. Register one modular route file per destination under `lib/routing/routes/home/` and export them through the folder barrel.
4. Make `/home` resolve to `/home/resume`; this preserves the legacy default index `0` while giving resume a linkable URL.
5. Keep the existing secondary routes (operators, sellers, comparisons, enterprise manager, and similar pages) beneath the home hierarchy during migration. Do not migrate their UI in this slice.
6. Bottom navigation must call `context.goNamed(...)`, never mutate an index or use `Navigator`/GetX.
7. Derive the selected bottom item from the matched route. Browser back, deep links, refresh, and programmatic navigation must therefore select the correct tab automatically.
8. Decide preservation behavior explicitly: use an indexed/stateful shell only if tab scroll/filter state must survive switching. Otherwise use a regular shell so inactive report providers can be disposed after their configured cache period. Start with a regular shell unless behavior testing proves preservation is required.

### Phase 1 validation

- Router tests cover `/home` redirect/default behavior, each named destination, deep links, browser back, and unknown routes.
- A widget test taps every bottom item and verifies both the visible placeholder page and route location.
- Existing secondary home child routes remain reachable.
- Stop after this slice for approval before building the app bar.

## Phase 2 — Home State and App Bar

1. Create immutable `HomeState` (one class in its own file) with:
   - selected date;
   - available BS enterprises;
   - selected enterprise ID;
   - selected-enterprise enabled state;
   - `AppMode`;
   - initialization/loading/error state as needed.
2. Create `HomeController` as a keep-alive Riverpod controller because its selection must survive navigation among home destinations. It coordinates repositories but does not load sale statistics.
3. Initialize in this order: load persisted app mode, obtain the active EC credentials/session, load BS enterprises, reconcile their enabled flags, and select the first valid legacy-compatible enterprise.
4. Create a home app-bar component based on `DefaultAppBar`, using `BaseAppBar`, shared dropdown/date components where suitable, theme colors, `Sizes`/gap constants, `.hardcoded` text, and `HookConsumerWidget` for local controls.
5. Preserve responsive behavior: enterprise selector plus date selector in portrait/landscape, enterprise-manager action, loading-disabled date action, and sales/financial-titles mode toggle.
6. Enterprise change calls only `HomeController.selectEnterprise`. Report pages react by constructing new params from the selected ID; this gives Riverpod a distinct cache key and avoids manual cross-presenter reload calls.
7. Date change calls only `HomeController.selectDate`. Each visible report page reloads through its parameter/controller contract.
8. Disabled enterprises remain visible but cannot be selected. Avoid the legacy unchecked list index in `enterpriseIsEnabled`; a missing sub-enterprise must safely evaluate as disabled.
9. App-mode changes must be persisted before publishing the new state. Define the financial-titles destination behavior before implementation: either a dedicated route outside the sales tab shell or a home child route with the bottom bar hidden.
10. Keep the enterprise-manager action routed with GoRouter. Do not open or navigate through a legacy presenter from the new app bar.

### Phase 2 validation

- Controller tests cover initialization, empty enterprise results, enabled/disabled selection, missing sub-enterprise metadata, date changes, persisted mode fallback, persistence failure, and rapid enterprise changes.
- Use latest-request-wins protection during asynchronous enterprise changes so an older completion cannot overwrite the newest selection.
- Widget tests cover portrait/landscape layout, loading/disabled controls, enterprise selection, date selection, mode toggle, and error feedback.
- Verify that changing enterprise/date causes only the visible report provider to load; it must not eagerly load every tab.
- Stop after this slice for approval before assembling the final body and navigation chrome.

## Phase 3 — Shell Body and Bottom Navigation

1. Build `HomePage` as the shell scaffold with the routed child as its body.
2. Put the shared app bar at shell level only for destinations that use it (resume, sales, products). Provide route metadata/configuration for destinations with a specialized header instead of nesting multiple scaffolds/app bars.
3. Add adaptive Material/Cupertino bottom navigation using the existing visual behavior as reference, but move the component into `features/home/presentation/pages/components` unless it is proven generic enough for `commom_widgets`.
4. Show the five destinations in the current order: resume, sales, products, personalized, more.
5. Preserve the legacy disabled-enterprise rule: when the selected enterprise is disabled, report destinations cannot be entered and the user receives themed feedback. Resume remains available to display the disabled-enterprise explanation.
6. Hide the sales bottom bar in financial-titles mode if that behavior is retained.
7. Replace the legacy full-screen `loadedEnterprises` overlay with `AsyncValueWidget`/`LoadingWidget` and explicit empty/error states.
8. Keep system-UI/orientation changes isolated in a hook/effect and restore them on disposal; do not reproduce `RouteAware`/GetX subscriptions.

### Phase 3 validation

- Widget tests verify app-bar visibility per destination, bottom-bar selection, disabled-enterprise blocking, financial-title mode, loading/error/empty states, orientation changes, and no nested scaffold visual defects.
- Manually validate Android, iOS, web width, portrait, landscape, keyboard visibility, and back navigation.
- Stop after shell validation before migrating report pages.

## Phase 4 — Migrate Report Pages One Complete Slice at a Time

The order minimizes complexity and validates the generic statistics controller before the most complicated page:

1. **Products**
   - Build daily/monthly params with `groupByProduct`, `groupByEnterprise`, `topCount: 200`, and the selected enterprise ID.
   - Migrate its period selector, filtering, table, refresh, empty, and error behavior.
2. **Sales**
   - Build hourly/daily/monthly/yearly params matching the legacy date-boundary rules and grouping flags.
   - Keep period selection as page-local presentation state; report data stays in `SaleStatisticsController`.
3. **Resume**
   - Treat this as an aggregation page, not one request. Create small presentation controllers/models only when they combine multiple `SaleStatisticsController` results (today, previous month/day, selected month, comparison period, goals).
   - Do not put aggregation/calculation logic in widgets.
4. **Personalized**
   - Keep the form/filter draft in a dedicated presentation controller.
   - On Generate, validate the date/grouping limits, create `GetSaleStatisticsParams`, and invoke/reuse `SaleStatisticsController`.
   - Preserve product top-count behavior (`300`) and the rule that product grouping removes time grouping.
5. **More**
   - Convert buttons to named GoRouter destinations and migrate logout to the active session controller/repository contract.
6. **Salesperson and other reports**
   - Add each as its own named page/route, generally reached from More.
   - Reuse `SaleStatisticsController` with `groupBySeller`, `groupByCashierOperator`, department, payment, or other flags instead of creating one network controller per report.

For every page: move one complete UI + state + tests slice, validate it, then remove or forward-export only that page's legacy implementation. Do not remove shared legacy code still used by unmigrated pages.

## Missing New-Architecture Contracts

The following legacy methods do not currently have equivalent datasource/repository contracts in `features` or `core` and must be added before the app bar/home initialization can be complete:

| Required behavior | Existing legacy implementation | Planned new contract | Layer/location |
|---|---|---|---|
| Load BS enterprises from `GET /api/enterprises` | `LoadEnterprises.get` / `RemoteLoadEnterprises` | `IHomeDatasource.getEnterprises(EcParams)` and `IHomeRepository.getEnterprises(EcParams)` | `features/home/data` + `features/home/domain` |
| Load and persist `AppMode` | `ManageAppMode.load/change` / `LocalManageAppMode` | `IHomeLocalDatasource.loadAppMode/saveAppMode` exposed through `IHomeRepository` | `features/home/data` + `features/home/domain` |
| Reconcile BS enterprises with Firebase enabled metadata and update missing entries | `GetxHomePresenter.getBsEnterprises` using `FirebaseManager.get/put` | Add narrowly named read/update methods to an existing core enterprise repository if one exists at implementation time; otherwise create a core enterprise datasource/repository because Firebase enterprise configuration is shared, not home-specific | `core/data` + `core/domain` |
| Observe Firebase sub-enterprise enabled changes | `GetxHomePresenter.initFirebaseStream` using `FirebaseFirestore.snapshots()` | `watchEnterpriseConfiguration(firebaseId)` stream contract; controller subscribes through Riverpod and disposal is automatic | `core/data` + `core/domain` |
| Switch the active account-level enterprise and persist its credentials | Partially handled by `ActiveEcParamsStateController.updateParams`; legacy manager switching is commented out | Extend/reuse the active session contract to update `EcParams` and the selected `FirebaseEnterpriseEntity` atomically; do not create a second source of truth in HomeController | `core/presentation` plus existing core storage |
| Logout and clear session safely | `GetxHomePresenter.doLogout` | Add/reuse a session repository/controller logout method that clears credentials and active EC params, then routes to splash/login | `core` or the existing authentication feature |

No new data contract is needed for selected date, selected bottom destination, selected BS sub-enterprise ID, or personalized form drafts; these are presentation state. No new sale-statistics datasource/repository is needed because `features/sale_statistics` already provides the required endpoint contract.

## SaleStatisticsController Adjustments to Plan Before Page Migration

1. Keep `CategoryGroupingType` in the provider family only if it truly distinguishes presentation caches; otherwise the full `GetSaleStatisticsParams` should become the provider key so loading can occur in `build` and parameter changes are naturally reactive.
2. Avoid `_lastLoadedParams` as the only cache guard across unrelated requests. Resume needs several simultaneous parameter sets, so each request must have its own provider instance or explicit aggregation providers.
3. Confirm whether `ref.watch(activeEcParamsStateControllerProvider)` should automatically clear stale data when credentials change. The current `build` returns an empty list, but a previously running request could still complete; add request-version/latest-wins protection if loading remains imperative.
4. Keep force refresh page-scoped by invalidating or refreshing only the exact parameterized provider.
5. Add controller tests for equal params caching, distinct params isolation, active EC changes, null EC params, force refresh, errors, and stale completion ordering.

## Cross-Cutting Acceptance Criteria

- No GetX import, presenter, factory, `Obx`, or `Get.find` exists in migrated home files.
- No new use case is introduced; controllers depend on repository interfaces.
- All imports use package barrels and every new folder has its barrel file.
- Domain entities are pure Dart and Equatable; models implement all required conversions with untyped `Map` JSON contracts.
- New datasource, repository, and controller public methods have focused tests with explicit mock arguments and EntityFactory data.
- No `build_runner` or Git command is run by Codex.
- Focused analyzer/tests pass for each approved slice before scope expands.
- Visual behavior is compared with the legacy HomePage on supported platforms before the legacy page is retired.

## Decisions Required Before Phase 2

1. Confirm whether financial titles remains a mode inside Home or becomes its own top-level route.
2. Confirm whether switching bottom tabs must preserve each page's scroll/filter state; this determines regular shell versus indexed/stateful shell.
3. Confirm whether the legacy Firebase reconciliation (automatically adding newly discovered BS enterprises as disabled) must remain automatic in the first home release.


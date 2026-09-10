---
trigger: model_decision
description: Activate when creating, modifying, styling, or reviewing Flutter UI widgets, screens, pages, or dialogs.
---

## Rules
- Never add commented file path headers above code blocks.
- Always import leaf barrel files, not individual files.
- Never use `faker` or mock data in UI widgets; pass real entities or UI state models.
- Extract sub-widgets into `components/` when file > 100 lines (follow `BuyRequestPage` pattern). Sub-widgets read providers directly (`ref.watch/read`) — no prop drilling.
- Wrap `Text` or dynamic content inside `Row` with `Expanded` or `Flexible`.
- Inline-init and dispose `TextEditingController` / `FocusNode` (no `late` unless dependent on `widget.*`).

## Reusable Widgets (`lib/commom_widgets/`)
- **Buttons**: `PrimaryButton`, `PrimaryTextButton`, `ActionTextButton`, `DefaultPaginationButtons`
- **Inputs**: `DefaultDropDown`, `DefaultSimpleDropDown`, `DefaultCheckBox`, `DefaultSwitch`, `DefaultChoiceChip`, `DefaultSegmentedButtons`
- **Layout**: `ResponsiveCenter`, `ResponsiveListFlow`, `ResponsiveScrollableWidget`
- **Label+Value**: Always use `TitleAndSubtitle` (never create custom `SummaryRow` / `KeyValueRow`).
- **Feedback & Overlays**: `LoadingCircle`, `LoadingExtension`, `EmptyPlaceholderWidget`, `AsyncValueWidget`, `AlertDialogs`, `ShowToastMessage`, `ShowModalPage`
- **Icons**: `PlatformIcon`

## Spacing (`lib/constants/app_sizes.dart`) & Theme
- Spacing: Use `Sizes.p4`…`Sizes.p120`, `gapW4`/`gapH4`…`gapW32`/`gapH32`, `gapSliverW4`/`gapSliverH4`. Never hardcode pixels.
- Theme: Texts `.hardcoded`. Opacity via `.withAlpha(0–255)` (`.withOpacity()` is forbidden). Colors from `context.theme.colorScheme` or `primaryColor` / `disabledColor` / `scaffoldBackgroundColor` (no hardcoded hex/RGB). Typography from `context.theme.textTheme.*`.

## Platform Adaptation (DRY)
Declare shared sub-widgets once before platform check:
```dart
final title = Row(children: [Expanded(child: Text(t)), const Icon(Icons.info)]);
if (PlatformUtil.isCupertino) return CupertinoWidget(title: title, ...);
return MaterialWidget(title: title, ...);
```
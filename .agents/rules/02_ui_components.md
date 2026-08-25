---
trigger: model_decision
description: Activate this rule whenever the user asks to create, modify, style, or review any Flutter UI components, widgets, screens, pages, or dialogs. This contains the required shared widgets, spacing/padding constants (Gaps), and theming rules
---

## Imports
- Never add commented file path headers above code blocks.
- Always import barrel files, not individual files.

## Reusable Widgets (check `lib/commom_widgets` first)
- **Buttons**: `PrimaryButton`, `PrimaryTextButton`, `ActionTextButton`, `DefaultPaginationButtons`
- **Inputs**: `DefaultDropDown`, `DefaultSimpleDropDown`, `DefaultCheckBox`, `DefaultSwitch`, `DefaultChoiceChip`, `DefaultSegmentedButtons`
- **Layout**: `ResponsiveCenter`, `ResponsiveListFlow`, `ResponsiveScrollableWidget`
- **Label+Value rows**: always use `TitleAndSubtitle` — never create custom `SummaryRow` or `KeyValueRow` widgets.
- **Feedback**: `LoadingCircle`, `LoadingExtension`, `EmptyPlaceholderWidget`, `AsyncValueWidget`
- **Overlays**: `AlertDialogs`, `ShowToastMessage`, `ShowModalPage`
- **Icons**: `PlatformIcon`

Never use `faker` or mock data in UI widgets. Always pass real entities or UI state models.

## Spacing (lib/constants/app_sizes.dart)
Never hardcode pixel values. Use:
- **Padding**: `Sizes.p4` … `Sizes.p120`
- **Row/Column gaps**: `gapW4/gapH4` … `gapW32/gapH32`
- **Sliver gaps**: `gapSliverW4/gapSliverH4` etc.

## Theme
- All texts → `.hardcoded`
- Opacity → `.withAlpha(0–255)`. **`.withOpacity()` is forbidden.**
- Colors → `context.theme.colorScheme` or `primaryColor / disabledColor / scaffoldBackgroundColor`. No hardcoded hex/RGB.
- Typography → `context.theme.textTheme.*`

## Widget Rules
- Extract sub-widgets into `components/` when file exceeds 100 lines.
- Extracted components read providers directly (`ref.watch/read`) — no prop drilling.
- Follow `BuyRequestPage` folder pattern.
- Never use `late` for `TextEditingController` or `FocusNode` unless value depends on `widget.*`. Initialize inline and dispose properly.
- Wrap `Text` or dynamic content inside `Row` with `Expanded` or `Flexible` to prevent overflow.

## Platform Adaptation (DRY)
Declare shared sub-widgets once as local variables before the platform check, then reference them in each branch:
```dart
final title = Row(children: [Expanded(child: Text(t)), const Icon(Icons.info)]);
if (PlatformUtil.isCupertino) return CupertinoWidget(title: title, ...);
return MaterialWidget(title: title, ...);
```
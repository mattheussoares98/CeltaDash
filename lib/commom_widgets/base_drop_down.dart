import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BaseDropDown<T> extends StatelessWidget {
  const BaseDropDown({
    required this.onChanged,
    required this.items,
    required this.selectedItem,
    required this.label,
    this.hint,
    this.dropdownHeight = 45,
    this.validator,
    this.showLabelAtTopLeft = false,
    this.isSimple = false,
    this.adviceMessage,
    this.onPrevious,
    this.onNext,
    super.key,
  });
  final void Function(T)? onChanged;
  final List<DropdownMenuItem<T>>? items;
  final Widget? hint;
  final T? selectedItem;
  final String? label;
  final double? dropdownHeight;
  final String? Function(T?)? validator;
  final bool showLabelAtTopLeft;
  final bool isSimple;
  final String? adviceMessage;
  final void Function()? onPrevious;
  final void Function()? onNext;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    final centeredItems = items?.map((item) {
      return DropdownMenuItem<T>(
        key: item.key,
        value: item.value,
        onTap: item.onTap,
        enabled: item.enabled,
        alignment: Alignment.center,
        child: Center(child: item.child),
      );
    }).toList();

    final topLeftLabel =
        selectedItem != null &&
            showLabelAtTopLeft &&
            (label?.isNotEmpty ?? false)
        ? Positioned(
            left: Sizes.p4,
            child: BaseText(
              label!,
              textType: TextType.caption,
              fontWeight: FontWeight.w300,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          )
        : null;

    final disabledColor = theme.disabledColor.withValues(alpha: .2);
    final enabledColor = theme.disabledColor.withValues(alpha: .1);

    final bool hasStepButtons = onPrevious != null || onNext != null;
    final bool isDropdownEnabled =
        onChanged != null && (centeredItems?.length ?? 0) > 0;

    if (PlatformUtil.isCupertino && !isSimple) {
      final double screenWidth = MediaQuery.sizeOf(context).width;
      final selectedMenuItem = centeredItems?.firstWhereOrNull(
        (item) => item.value == selectedItem,
      );

      return FormField<T>(
        key: key,
        autovalidateMode: AutovalidateMode.onUserInteractionIfError,
        validator: validator,
        initialValue: selectedItem,
        builder: (state) {
          return Column(
            children: [
              SizedBox(
                height: dropdownHeight,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: isDropdownEnabled ? enabledColor : disabledColor,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(Sizes.p8),
                    ),
                  ),
                  child: Stack(
                    children: [
                      ?topLeftLabel,
                      Row(
                        children: [
                          if (hasStepButtons)
                            BaseIconButton(
                              targetSize: dropdownHeight,
                              platformIcon: const PlatformIcon(
                                cupertinoIcon: CupertinoIcons.chevron_left,
                                materialIcon: Icons.chevron_left,
                              ),
                              onPressed: onPrevious,
                            ),
                          Expanded(
                            child: CupertinoButton(
                              padding: EdgeInsets.only(
                                left: hasStepButtons ? 0 : 15,
                              ),
                              onPressed:
                                  onChanged == null ||
                                      (centeredItems?.length ?? 0) < 1
                                  ? null
                                  : () async {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      if (adviceMessage != null) {
                                        final ok = await showAlertDialog(
                                          context: context,
                                          title: 'Atenção!'.hardcoded,
                                          content: adviceMessage,
                                          defaultActionText:
                                              'Continuar'.hardcoded,
                                          cancelActionText:
                                              'Cancelar'.hardcoded,
                                        );
                                        if (ok != true) return;
                                      }
                                      if (context.mounted) {
                                        final selected = await showCupertinoModalPopup<T>(
                                          context: context,
                                          builder: (sheetContext) =>
                                              CupertinoActionSheet(
                                                title: BaseText(
                                                  'Selecionar'.hardcoded,
                                                ),
                                                actions: centeredItems!.map((
                                                  item,
                                                ) {
                                                  return CupertinoActionSheetAction(
                                                    onPressed: () {
                                                      if (item.enabled) {
                                                        Navigator.of(
                                                          sheetContext,
                                                        ).pop(item.value);
                                                      }
                                                    },
                                                    child: item.child,
                                                  );
                                                }).toList(),
                                                cancelButton:
                                                    CupertinoActionSheetAction(
                                                      isDefaultAction: true,
                                                      onPressed: () =>
                                                          Navigator.of(
                                                            sheetContext,
                                                          ).pop(),
                                                      child: BaseText.titleMedium(
                                                        'Cancelar'.hardcoded,
                                                        color: CupertinoColors
                                                            .destructiveRed,
                                                      ),
                                                    ),
                                              ),
                                        );

                                        if (selected != null &&
                                            onChanged != null) {
                                          state.didChange(selected);
                                          onChanged!(selected);
                                        }
                                      }
                                    },
                              child: Row(
                                children: [
                                  Expanded(
                                    child: selectedMenuItem != null
                                        ? DefaultTextStyle(
                                            style:
                                                theme.textTheme.bodyLarge ??
                                                const TextStyle(),
                                            textAlign: TextAlign.center,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            child: selectedMenuItem.child,
                                          )
                                        : Center(
                                            child:
                                                hint ??
                                                BaseText(
                                                  label ??
                                                      'Selecionar'.hardcoded,
                                                  textType: TextType.bodyLarge,
                                                  maxLines: 1,
                                                  textAlign: TextAlign.center,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                          ),
                                  ),
                                  if (!hasStepButtons && screenWidth > 300)
                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: Sizes.p16,
                                      ),
                                      child: Icon(CupertinoIcons.chevron_down),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          if (hasStepButtons)
                            BaseIconButton(
                              targetSize: dropdownHeight,
                              platformIcon: const PlatformIcon(
                                cupertinoIcon: CupertinoIcons.chevron_right,
                                materialIcon: Icons.chevron_right,
                              ),
                              onPressed: onNext,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (state.hasError)
                Padding(
                  padding: const EdgeInsets.only(top: 5, left: 15),
                  child: BaseText.bodySmall(
                    state.errorText!,
                    color: CupertinoColors.systemRed,
                  ),
                ),
            ],
          );
        },
      );
    }

    return FormField<T>(
      key: key,
      autovalidateMode: AutovalidateMode.onUserInteractionIfError,
      validator: validator,
      initialValue: selectedItem,
      builder: (state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: dropdownHeight,
              child: Material(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(Sizes.p8)),
                ),
                color: isDropdownEnabled ? enabledColor : disabledColor,
                child: InkWell(
                  onTap: isDropdownEnabled ? () {} : null,
                  customBorder: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(Sizes.p8)),
                  ),
                  child: Stack(
                    children: [
                      ?topLeftLabel,
                      Row(
                        children: [
                          if (hasStepButtons)
                            BaseIconButton(
                              targetSize: dropdownHeight,
                              platformIcon: const PlatformIcon(
                                cupertinoIcon: CupertinoIcons.chevron_left,
                                materialIcon: Icons.chevron_left,
                              ),
                              onPressed: onPrevious,
                            ),
                          Expanded(
                            child: Align(
                              child: DropdownButtonFormField<T>(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteractionIfError,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  focusedErrorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                  isDense: true,
                                  errorStyle: TextStyle(height: 0, fontSize: 0),
                                ),
                                focusColor: Colors.transparent,
                                padding: const EdgeInsets.only(left: Sizes.p8),
                                dropdownColor: theme.colorScheme.surface,
                                initialValue: selectedItem,
                                isExpanded: true,
                                alignment: Alignment.center,
                                iconSize: hasStepButtons ? 0 : 17,
                                icon: hasStepButtons
                                    ? const SizedBox.shrink()
                                    : const Icon(Icons.arrow_drop_down),
                                onTap: adviceMessage == null
                                    ? null
                                    : () {
                                        showAlertDialog(
                                          context: context,
                                          title: 'Atenção!'.hardcoded,
                                          content: adviceMessage,
                                        );
                                      },
                                hint:
                                    hint ??
                                    (label != null ? BaseText(label!) : null),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                      theme.textTheme.titleMedium?.fontSize,
                                  color: theme.colorScheme.onSurface,
                                  height: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                items: centeredItems,
                                onChanged:
                                    onChanged == null ||
                                        (centeredItems?.length ?? 0) < 1
                                    ? null
                                    : (value) {
                                        if (value != null) {
                                          state.didChange(value);
                                          onChanged?.call(value);
                                        }
                                      },
                              ),
                            ),
                          ),
                          if (hasStepButtons)
                            BaseIconButton(
                              targetSize: dropdownHeight,
                              platformIcon: const PlatformIcon(
                                cupertinoIcon: CupertinoIcons.chevron_right,
                                materialIcon: Icons.chevron_right,
                              ),
                              onPressed: onNext,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(top: Sizes.p4),
                child: BaseText.bodySmall(
                  state.errorText!,
                  color: theme.colorScheme.error,
                ),
              ),
          ],
        );
      },
    );
  }
}

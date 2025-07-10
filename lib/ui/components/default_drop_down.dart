import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helpers/helpers.dart';

class DefaultDropDown<T> extends StatefulWidget {
  final void Function(T)? onChanged;
  final List<DropdownMenuItem<T>>? items;
  final Widget? hint;
  final T selectedItem;
  final String? label;

  const DefaultDropDown({
    required this.onChanged,
    required this.hint,
    required this.items,
    required this.selectedItem,
    required this.label,
    super.key,
  });

  @override
  State<DefaultDropDown<T>> createState() => _DefaultDropDownState<T>();
}

class _DefaultDropDownState<T> extends State<DefaultDropDown<T>> {
  @override
  Widget build(BuildContext context) {
    // Find the index of the currently selected item.
    final currentIndex =
        widget.items?.indexWhere((item) => item.value == widget.selectedItem) ??
            -1;
    final bool hasPrevious = currentIndex > 0;
    final bool hasNext =
        currentIndex != -1 && currentIndex < (widget.items?.length ?? 0) - 1;

    if (Platform.isIOS) {
      return SizedBox(
        height: DropdownHeight.height,
        child: CupertinoButton(
          disabledColor: Theme.of(context).disabledColor.withAlpha(100),
          padding: const EdgeInsets.only(left: 0),
          color: IsDarkTheme.isDark
              ? Theme.of(context).disabledColor
              : Theme.of(context).disabledColor.withAlpha(40),
          onPressed:
              widget.onChanged == null || (widget.items?.length ?? 0) <= 1
                  ? null
                  : () async {
                      final selected = await showCupertinoModalPopup<T>(
                        context: context,
                        builder: (_) => CupertinoActionSheet(
                          title: Text(R.string.selectOneEnterprise),
                          actions: widget.items!.map((item) {
                            String text = '';
                            if (item.child is Text) {
                              final textWidget = item.child as Text;
                              text = textWidget.data ?? '';
                            }

                            Color getColor() {
                              if (item.enabled == false) {
                                return Colors.red;
                              } else if (item.value == widget.selectedItem) {
                                return Theme.of(context).primaryColorDark;
                              } else {
                                return Theme.of(context).disabledColor;
                              }
                            }

                            return CupertinoActionSheetAction(
                              onPressed: () {
                                Navigator.of(context).pop(item.value);
                              },
                              child: Text(
                                text,
                                style: TextStyle(
                                  color: getColor(),
                                ),
                              ),
                            );
                          }).toList(),
                          cancelButton: CupertinoActionSheetAction(
                            isDefaultAction: true,
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(R.string.cancel),
                          ),
                        ),
                      );

                      if (selected != null && widget.onChanged != null) {
                        widget.onChanged!(selected);
                      }
                    },
          child: Align(
            alignment: Alignment.center,
            child: Row(
              children: [
                // Left Arrow Button - only visible if there's a previous item
                if (hasPrevious)
                  _ChangeItemByArrow(
                    isPrevious: true,
                    items: widget.items,
                    selectedItem: widget.selectedItem,
                    onChanged: widget.onChanged,
                    index: currentIndex,
                  ),
                Expanded(
                  child: Text(
                    widget.label ?? R.string.select,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: StringSize.size,
                      color: Theme.of(context).textTheme.titleMedium?.color,
                    ),
                  ),
                ),
                // Right Arrow Button - only visible if there's a next item
                if (hasNext)
                  _ChangeItemByArrow(
                    isPrevious: false,
                    items: widget.items,
                    selectedItem: widget.selectedItem,
                    onChanged: widget.onChanged,
                    index: currentIndex,
                  ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      height: DropdownHeight.height,
      decoration: BoxDecoration(
        color: IsDarkTheme.isDark
            ? Theme.of(context).disabledColor
            : Theme.of(context).disabledColor.withAlpha(40),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          if (hasPrevious)
            _ChangeItemByArrow(
              isPrevious: true,
              items: widget.items,
              selectedItem: widget.selectedItem,
              onChanged: widget.onChanged,
              index: currentIndex,
            ),
          Expanded(
            child: DropdownButtonFormField<T>(
              value: widget.selectedItem,
              items: widget.items,
              onChanged:
                  widget.onChanged == null || (widget.items?.length ?? 0) <= 1
                      ? null
                      : (value) {
                          if (value != null && widget.onChanged != null) {
                            widget.onChanged!(value);
                          }
                        },
              isExpanded: true,
              alignment: Alignment.center,
              // Use selectedItemBuilder to show the custom label when closed
              selectedItemBuilder: (context) {
                return widget.items?.map<Widget>((item) {
                      return Center(
                        child: Text(
                          widget.label ?? R.string.select,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: StringSize.size,
                            color:
                                Theme.of(context).textTheme.titleMedium?.color,
                          ),
                        ),
                      );
                    }).toList() ??
                    [];
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: !hasPrevious
                    ? const EdgeInsets.only(left: 8)
                    : EdgeInsets.zero,
                fillColor: Colors.transparent,
                enabledBorder: InputBorder.none,
              ),
              // Hide the default dropdown arrow
              icon: const SizedBox.shrink(),
              dropdownColor: IsDarkTheme.isDark
                  ? Theme.of(context).scaffoldBackgroundColor
                  : Colors.white,
              style: TextStyle(
                fontSize: StringSize.size,
                color: Theme.of(context).textTheme.titleMedium?.color,
              ),
            ),
          ),
          if (hasNext)
            _ChangeItemByArrow(
              isPrevious: false,
              items: widget.items,
              selectedItem: widget.selectedItem,
              onChanged: widget.onChanged,
              index: currentIndex,
            ),
        ],
      ),
    );
  }
}

class _ChangeItemByArrow<T> extends StatelessWidget {
  final bool isPrevious;
  final List<DropdownMenuItem<T>>? items;
  final T selectedItem;
  final void Function(T item)? onChanged;
  final int index;
  const _ChangeItemByArrow({
    super.key,
    required this.isPrevious,
    required this.items,
    required this.selectedItem,
    required this.onChanged,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: true,
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      child: IconButton(
        onPressed: () {
          if (onChanged != null && isPrevious) {
            final previousItemValue = items![index - 1].value;
            if (previousItemValue != null) {
              onChanged!(previousItemValue);
            }
          } else {
            if (onChanged != null) {
              final nextItemValue = items![index + 1].value;
              if (nextItemValue != null) {
                onChanged!(nextItemValue);
              }
            }
          }
        },
        icon: Icon(
          Platform.isIOS
              ? (isPrevious
                  ? CupertinoIcons.arrow_left
                  : CupertinoIcons.arrow_right)
              : (isPrevious ? Icons.arrow_left : Icons.arrow_right),
        ),
      ),
    );
  }
}

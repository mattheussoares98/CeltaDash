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
    if (Platform.isIOS) {
      return SizedBox(
        height: DropdownHeight.height,
        child: CupertinoButton(
          disabledColor: Theme.of(context).disabledColor.withAlpha(100),
          padding: EdgeInsets.only(left: 15),
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
            child: Text(
              widget.label ?? R.string.select,
              maxLines: 1,
              style: TextStyle(
                fontSize: StringSize.size,
                color: Theme.of(context).textTheme.titleMedium?.color,
              ),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: DropdownHeight.height,
      child: DropdownButtonFormField<T>(
        decoration: InputDecoration(
          isDense: true,
          fillColor: IsDarkTheme.isDark
              ? Theme.of(context).disabledColor
              : Theme.of(context).disabledColor.withAlpha(40),
          focusColor: Theme.of(context).disabledColor.withAlpha(40),
        ),
        isDense: true,
        validator: (value) {
          return null;
        },
        value: widget.selectedItem,
        isExpanded: true,
        alignment: Alignment.center,
        iconSize: 17,
        hint: widget.hint,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: StringSize.size,
          color: Colors.white,
          height: 1,
        ),
        items: widget.items,
        onChanged: widget.onChanged == null || (widget.items?.length ?? 0) <= 1
            ? null
            : (value) {
                if (value != null && widget.onChanged != null) {
                  widget.onChanged!(value);
                }
              },
      ),
    );
  }
}

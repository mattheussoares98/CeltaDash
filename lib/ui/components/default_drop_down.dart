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
    final color = MediaQuery.of(context).platformBrightness == Brightness.dark
        ? CupertinoColors.black
        : CupertinoColors.systemGrey5;
    if (Platform.isIOS) {
      return SizedBox(
        height: DropdownHeight.height,
        child: CupertinoButton(
          color: color,
          disabledColor: Theme.of(context).disabledColor,
          padding: EdgeInsets.only(left: 15), // Remove internal padding
          onPressed: widget.onChanged == null
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

                        return CupertinoActionSheetAction(
                          onPressed: () {
                            Navigator.of(context).pop(item.value);
                          },
                          child: Text(
                            text,
                            style: TextStyle(
                              color: item.value == widget.selectedItem
                                  ? Theme.of(context).primaryColorDark
                                  : Theme.of(context).disabledColor,
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
                color: CupertinoColors.black,
              ),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: DropdownHeight.height,
      child: DropdownButtonFormField<T>(
        decoration: const InputDecoration(
          isDense: true,
        ),
        isDense: true,
        validator: (value) {
          return null;
        },
        dropdownColor:
            MediaQuery.of(context).platformBrightness == Brightness.dark
                ? Theme.of(context).disabledColor
                : Colors.white,
        value: widget.selectedItem,
        isExpanded: true,
        alignment: Alignment.center,
        iconSize: 17,
        hint: widget.hint,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: StringSize.size,
          color: Colors.black,
          height: 1,
        ),
        items: widget.items,
        onChanged: widget.onChanged == null
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

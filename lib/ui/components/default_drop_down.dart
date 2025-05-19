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
      return CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        color: CupertinoColors.systemGrey5,
        disabledColor: CupertinoColors.systemGrey3,
        onPressed: widget.onChanged == null
            ? null
            : () async {
                final selected = await showCupertinoModalPopup<T>(
                  context: context,
                  builder: (_) => CupertinoActionSheet(
                    title: Text(R.string.selectOneEnterprise),
                    actions: widget.items!
                        .map((item) => CupertinoActionSheetAction(
                              onPressed: () {
                                Navigator.of(context).pop(item.value);
                              },
                              child: item.child,
                            ))
                        .toList(),
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
      );
    }

    return DropdownButtonFormField<T>(
      decoration: const InputDecoration(isDense: true),
      validator: (value) {
        return null;
      },
      value: widget.selectedItem,
      isExpanded: true,
      alignment: Alignment.center,
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
    );
  }
}

import 'package:flutter/material.dart';

import '../helpers/helpers.dart';

class DefaultDropDown<T> extends StatefulWidget {
  final void Function(T) onChanged;
  final List<DropdownMenuItem<T>>? items;
  final Widget? hint;
  final T selectedItem;

  const DefaultDropDown({
    required this.onChanged,
    required this.hint,
    required this.items,
    required this.selectedItem,
    super.key,
  });

  @override
  State<DefaultDropDown<T>> createState() => _DefaultDropDownState<T>();
}

class _DefaultDropDownState<T> extends State<DefaultDropDown<T>> {
  @override
  Widget build(BuildContext context) {
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
      onChanged: (value) {
        if (value != null) {
          widget.onChanged(value);
        }
      },
    );
  }
}

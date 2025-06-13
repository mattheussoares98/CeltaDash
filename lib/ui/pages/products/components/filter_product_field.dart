import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';

class FilterProductField extends StatelessWidget {
  final TextEditingController filterProductController;
  final StateSetter setState;
  const FilterProductField({
    super.key,
    required this.filterProductController,
    required this.setState,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: SizedBox(
        height: 40,
        child: TextFormField(
          controller: filterProductController,
          onChanged: (_) {
            setState(() {});
          },
          maxLength: 50,
          decoration: FormFieldDecoration.decoration(
            context: context,
            labelText: R.string.filter,
            hintText: R.string.filter,
            suffixIcon: Icon(
              Platform.isIOS ? CupertinoIcons.search : Icons.search,
            ),
          ),
        ),
      ),
    );
  }
}

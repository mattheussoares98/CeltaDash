import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';

class FilterProductField extends StatelessWidget {
  final TextEditingController filterProductController;
  final StateSetter setState;
  final bool isLoading;
  const FilterProductField({
    super.key,
    required this.filterProductController,
    required this.setState,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final isIOS = !kIsWeb && Platform.isIOS;

    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: SizedBox(
        height: 40,
        child: TextFormField(
          enabled: !isLoading,
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
              isIOS ? CupertinoIcons.search : Icons.search,
            ),
          ),
        ),
      ),
    );
  }
}

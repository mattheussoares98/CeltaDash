import 'package:flutter/material.dart';

import '../helpers.dart';

class FormFieldDecoration {
  static InputDecoration decoration({
    required BuildContext context,
    String? labelText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    String? errorText,
    String? hintText,
    bool showCounterText = false,
    double? fontSize,
  }) =>
      InputDecoration(
        labelText: labelText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        errorText: errorText,
        hintText: hintText,
        counterText: showCounterText == false ? "" : null,
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            style: BorderStyle.solid,
            width: 1,
            color: Color.fromARGB(255, 171, 35, 35),
          ),
        ),
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: fontSize ?? StringSize.size,
          // fontWeight: FontWeight.bold,
        ),
        labelStyle: TextStyle(
          color: Colors.black,
          // fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
          fontSize: fontSize ?? StringSize.size,
        ),
        floatingLabelStyle: TextStyle(
          color: Colors.black,
          // fontWeight: FontWeight.bold,
          fontSize: fontSize ?? StringSize.size,
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            style: BorderStyle.solid,
            width: 1,
            color: Colors.grey,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            style: BorderStyle.solid,
            width: 1,
            color: Colors.grey,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            style: BorderStyle.solid,
            width: 1,
            color: Color.fromARGB(255, 171, 35, 35),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            style: BorderStyle.solid,
            width: 1,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            style: BorderStyle.solid,
            width: 1,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      );
}

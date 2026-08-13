import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';

class DefaultFormFieldDecoration extends InputDecoration {
  DefaultFormFieldDecoration(
    BuildContext context, {
    super.labelText,
    super.prefixIcon,
    super.suffixIcon,
    super.errorText,
    super.hintText,
    bool showCounterText = false,
    double? fontSize,
  }) : super(
         counterText: showCounterText == false ? "" : null,
         suffixIconColor: context.theme.colorScheme.primary,
         prefixIconColor: context.theme.colorScheme.primary,
         errorBorder: OutlineInputBorder(
           borderRadius: BorderRadius.circular(10),
           borderSide: const BorderSide(
             color: Color.fromARGB(255, 171, 35, 35),
           ),
         ),
         hintStyle: TextStyle(
           color: Colors.grey,
           fontSize: fontSize ?? context.theme.textTheme.bodyLarge?.fontSize,
         ),
         labelStyle: TextStyle(
           color: Colors.black,
           fontStyle: FontStyle.italic,
           fontSize: fontSize ?? context.theme.textTheme.bodyLarge?.fontSize,
         ),
         floatingLabelStyle: TextStyle(
           color: Colors.black,
           fontSize: fontSize ?? context.theme.textTheme.bodyLarge?.fontSize,
         ),
         disabledBorder: OutlineInputBorder(
           borderRadius: BorderRadius.circular(10),
           borderSide: const BorderSide(color: Colors.grey),
         ),
         enabledBorder: OutlineInputBorder(
           borderRadius: BorderRadius.circular(10),
           borderSide: const BorderSide(color: Colors.grey),
         ),
         focusedErrorBorder: OutlineInputBorder(
           borderRadius: BorderRadius.circular(10),
           borderSide: const BorderSide(
             color: Color.fromARGB(255, 171, 35, 35),
           ),
         ),
         focusedBorder: OutlineInputBorder(
           borderRadius: BorderRadius.circular(10),
           borderSide: BorderSide(color: context.theme.colorScheme.primary),
         ),
         border: OutlineInputBorder(
           borderRadius: BorderRadius.circular(10),
           borderSide: BorderSide(color: context.theme.colorScheme.primary),
         ),
       );
}

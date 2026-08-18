import 'package:celta_dash/commom_widgets/form_field/form_field.dart';
import 'package:celta_dash/ui/themes/app_decorations.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BaseTextFormField extends StatelessWidget {
  final bool? enabled;
  final TextEditingController? controller;
  final void Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;
  final String? labelText;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? errorText;
  final bool obscureText;
  final AutovalidateMode? autovalidateMode;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final int? maxLength;
  final Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final VoidCallback? onTap;
  final int? maxLines;
  final bool? autofocus;
  final TextInputAction? textInputAction;
  final VoidCallback? onEditingComplete;
  final Iterable<String>? autofillHints;
  final EdgeInsets scrollPadding;
  const BaseTextFormField({
    super.key,
    this.maxLength = 50,
    this.controller,
    this.enabled = true,
    this.onFieldSubmitted,
    this.validator,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.errorText,
    this.autovalidateMode,
    this.focusNode,
    this.keyboardType,
    this.onChanged,
    this.inputFormatters,
    this.onTap,
    this.maxLines,
    this.textInputAction,
    this.onEditingComplete,
    this.obscureText = false,
    this.autofocus = false,
    this.autofillHints,
    this.scrollPadding = const EdgeInsets.all(Sizes.p20),
  });

  @override
  Widget build(BuildContext context) {
    if (PlatformUtil.isCupertino) {
      return CupertinoFormField(baseTextFormField: this, key: key);
    }
    return Padding(
      padding: const EdgeInsets.only(top: Sizes.p4),
      child: TextFormField(
        key: key,
        textInputAction: textInputAction,
        onEditingComplete: onEditingComplete,
        minLines: 1,
        maxLines: maxLines ?? 1,
        enabled: enabled,
        controller: controller,
        autovalidateMode: autovalidateMode,
        onFieldSubmitted: onFieldSubmitted,
        inputFormatters: inputFormatters,
        validator: validator,
        obscureText: obscureText,
        focusNode: focusNode,
        keyboardType: keyboardType,
        maxLength: maxLength,
        onChanged: onChanged,
        onTap: onTap,
        autofocus: autofocus == true,
        autofillHints: autofillHints,
        scrollPadding: scrollPadding,
        buildCounter:
            (
              context, {
              required currentLength,
              required isFocused,
              required maxLength,
            }) => null,
        decoration: AppDecorations.input(
          enabled: enabled ?? true,
          context: context,
          labelText: labelText,
          hintText: hintText,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          errorText: errorText,
          isMultiLine: (maxLines ?? 1) > 1,
        ),
      ),
    );
  }
}

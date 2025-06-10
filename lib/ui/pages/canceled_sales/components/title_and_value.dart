import 'package:flutter/material.dart';

class TitleAndValue extends StatelessWidget {
  final String? title;
  final String? value;
  const TitleAndValue({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    if (title?.isNotEmpty == true && value?.isNotEmpty == true) {
      return Text("$title: $value");
    }
    return SizedBox();
  }
}

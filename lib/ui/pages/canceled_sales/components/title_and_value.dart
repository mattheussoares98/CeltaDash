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
      return RichText(
        text: TextSpan(
          text: "$title: ",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          children: [
            TextSpan(
              text: value,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
          ],
        ),
      );
    }
    return SizedBox();
  }
}

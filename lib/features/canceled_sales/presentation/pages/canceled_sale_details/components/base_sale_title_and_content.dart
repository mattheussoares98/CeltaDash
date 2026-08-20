import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';

class BaseSaleTitleAndContent extends StatelessWidget {
  const BaseSaleTitleAndContent({
    super.key,
    required this.title,
    required this.content,
  });
  final String title;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .stretch,
      children: [
        BaseText.titleMedium(title, color: context.theme.primaryColor),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(Sizes.p8),
            child: content,
          ),
        ),
      ],
    );
  }
}

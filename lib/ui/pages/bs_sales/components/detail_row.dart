import 'package:flutter/material.dart';

class DetailRow extends StatelessWidget {
  final String title;
  final String? value;
  final int? titleFlex;
  final int? valueFlex;

  const DetailRow({
    super.key,
    required this.title,
    this.value,
    this.titleFlex,
    this.valueFlex,
  });

  @override
  Widget build(BuildContext context) {
    if (value == null || value!.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: titleFlex ?? 2,
          child: Text(
            title,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: valueFlex ?? 3,
          child: Text(
            value!,
            textAlign: TextAlign.end,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }
}

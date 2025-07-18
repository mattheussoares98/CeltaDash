import 'dart:math';

import 'package:flutter/material.dart';

class EmptySales extends StatelessWidget {
  final bool? isLoading;
  const EmptySales({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final height = mediaQuery.size.height;

    final imageSize = min(width, height) * 0.7;

    return Center(
      child: isLoading == true
          ? const SizedBox.shrink()
          : Image.asset(
              "lib/ui/assets/images/empty_sales.png",
              width: imageSize,
              height: imageSize,
            ),
    );
  }
}

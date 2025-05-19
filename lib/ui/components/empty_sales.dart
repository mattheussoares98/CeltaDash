import 'package:flutter/material.dart';

class EmptySales extends StatelessWidget {
  final bool? isLoading;
  const EmptySales({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: isLoading == true
            ? SizedBox.shrink()
            : Image.asset("lib/ui/assets/images/empty_sales.png"));
  }
}

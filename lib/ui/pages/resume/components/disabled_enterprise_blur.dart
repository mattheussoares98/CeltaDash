import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';

class DisabledEnterpriseBlur extends StatelessWidget {
  const DisabledEnterpriseBlur({super.key});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ui.ImageFilter.blur(
          sigmaX: 6, sigmaY: 6, tileMode: TileMode.repeated),
      child: Container(
        // This container defines the area of the blur.
        // A slight color tint enhances the "frosted glass" look.
        color: Colors.black.withAlpha(30),
        child: Center(
          child: Text(
            R.string.msgDisabledEnterprise,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Colors.red,
              shadows: const [
                Shadow(
                  color: Colors.white,
                  offset: Offset(0, 0),
                  blurRadius: 1,
                ),
                Shadow(
                  color: Colors.white,
                  offset: Offset(-1, -1),
                  blurRadius: 1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

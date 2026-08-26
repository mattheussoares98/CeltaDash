import 'dart:ui' as ui;

import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';

class DisabledEnterpriseOverlay extends StatelessWidget {
  const DisabledEnterpriseOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(
          sigmaX: 6,
          sigmaY: 6,
          tileMode: TileMode.repeated,
        ),
        child: ColoredBox(
          color: context.colorScheme.scrim.withAlpha(30),
          child: Center(
            child: Text(
              'A empresa não está habilitada. Entre em contato com o setor '
                      'administrativo para habilitar'
                  .hardcoded,
              textAlign: TextAlign.center,
              style: context.theme.textTheme.headlineMedium?.copyWith(
                color: context.colorScheme.error,
                shadows: [
                  Shadow(color: context.colorScheme.surface, blurRadius: 1),
                  Shadow(
                    color: context.colorScheme.surface,
                    offset: const Offset(-1, -1),
                    blurRadius: 1,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

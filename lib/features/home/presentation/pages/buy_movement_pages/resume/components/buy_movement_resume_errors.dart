import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

class BuyMovementResumeErrors extends ConsumerWidget {
  const BuyMovementResumeErrors({required this.errors, super.key});

  final List<
    ({ProviderBase<AsyncValue<dynamic>> provider, AsyncValue<dynamic> value})
  >
  errors;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      children: [
        for (final error in errors)
          AsyncValueWidget(
            value: error.value,
            preserveValue: true,
            tryAgain: null,
            data: (_) => const SizedBox.shrink(),
          ),
        gapH16,
        Center(
          child: PrimaryTextButton(
            text: 'Tentar novamente'.hardcoded,
            onPressed: () {
              for (final error in errors) {
                ref.invalidate(error.provider);
              }
            },
            platformIcon: const PlatformIcon(
              cupertinoIcon: CupertinoIcons.refresh,
              materialIcon: Icons.refresh,
            ),
          ),
        ),
      ],
    );
  }
}

// lib/features/home/presentation/pages/personalized/components/personalized_generate_button.dart
import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PersonalizedGenerateButton extends HookConsumerWidget {
  const PersonalizedGenerateButton({super.key, this.onGenerateSuccess});

  final VoidCallback? onGenerateSuccess;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isGenerating = ref.watch(
      personalizedControllerProvider.select((s) => s.isGenerating),
    );
    final validationError = ref.watch(
      personalizedControllerProvider.select((s) => s.validationError),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (validationError != null) ...[
          Container(
            padding: const EdgeInsets.all(Sizes.p8),
            decoration: BoxDecoration(
              color: context.colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(Sizes.p8),
            ),
            child: BaseText.bodySmall(
              validationError,
              color: context.colorScheme.onErrorContainer,
            ),
          ),
          gapH8,
        ],
        PrimaryButton(
          text: 'Gerar'.hardcoded,
          isLoading: isGenerating,
          onPressed: isGenerating
              ? null
              : () async {
                  final succeeds = await ref
                      .read(personalizedControllerProvider.notifier)
                      .generateReport();
                  if (succeeds) {
                    onGenerateSuccess?.call();
                  }
                },
        ),
      ],
    );
  }
}

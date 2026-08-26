// lib/features/home/presentation/pages/components/enterprise_guard.dart
import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/home/presentation/controllers/controllers.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EnterpriseGuard extends ConsumerWidget {
  const EnterpriseGuard({
    super.key,
    required this.builder,
    this.fallback,
    this.preserveValue = false,
  });

  final Widget Function(BuildContext context, int enterpriseId) builder;
  final Widget? fallback;
  final bool preserveValue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeAsync = ref.watch(homeControllerProvider);

    if (homeAsync.hasError) {
      return const SizedBox.shrink();
    }

    return AsyncValueWidget(
      value: homeAsync,
      preserveValue: preserveValue,
      tryAgain: () {
        ref.invalidate(enterprisesControllerProvider);
        ref.invalidate(homeControllerProvider);
      },
      data: (homeState) {
        final enterpriseId = homeState.selectedEnterpriseId;
        if (enterpriseId == null) {
          return fallback ??
              Center(
                child: BaseText.error('Nenhuma empresa selecionada'.hardcoded),
              );
        }
        return builder(context, enterpriseId);
      },
    );
  }
}

import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/exceptions/exceptions.dart';
import 'package:celta_dash/features/enterprises_manager/presentation/controllers/controllers.dart';
import 'package:celta_dash/features/enterprises_manager/presentation/pages/components/components.dart';
import 'package:celta_dash/routing/routing.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EnterprisesManagerPage extends ConsumerWidget {
  const EnterprisesManagerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(enterprisesManagerControllerProvider, (previous, next) {
      final previousError = previous?.value?.actionError;
      final nextError = next.value?.actionError;
      if (nextError != null && nextError != previousError) {
        showToastMessage(parseErrorMessage(nextError), type: ToastType.error);
      }
    });
    final state = ref.watch(enterprisesManagerControllerProvider);

    return BaseScaffold(
      isScrollable: false,
      appBar: BaseAppBar(
        titleWidget: GestureDetector(
          onLongPress: () => context.pushNamed(Routes.webLogin.name),
          child: BaseText.titleLarge('Empresas conectadas'.hardcoded),
        ),
      ),
      body: AsyncValueWidget(
        value: state,
        preserveValue: true,
        tryAgain: () => ref.invalidate(enterprisesManagerControllerProvider),
        data: (_) => const EnterprisesManagerContent(),
      ),
    );
  }
}

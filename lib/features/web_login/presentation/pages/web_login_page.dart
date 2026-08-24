import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/exceptions/exceptions.dart';
import 'package:celta_dash/features/web_login/presentation/controllers/controllers.dart';
import 'package:celta_dash/features/web_login/presentation/pages/components/components.dart';
import 'package:celta_dash/routing/routing.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WebLoginPage extends ConsumerWidget {
  const WebLoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(webLoginControllerProvider, (previous, next) {
      final previousState = previous?.value;
      final nextState = next.value;
      if (nextState?.actionError != null &&
          nextState?.actionError != previousState?.actionError) {
        showToastMessage(
          parseErrorMessage(nextState!.actionError),
          type: ToastType.error,
        );
      }
      if (nextState?.isAuthenticated == true &&
          previousState?.isAuthenticated != true) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            context.goNamed(Routes.webEnterprises.name);
          }
        });
      }
    });
    final state = ref.watch(webLoginControllerProvider);

    return BaseScaffold(
      isScrollable: false,
      appBar: BaseAppBar(title: 'Login web'.hardcoded),
      body: AsyncValueWidget(
        value: state,
        tryAgain: () => ref.invalidate(webLoginControllerProvider),
        data: (loginState) => WebLoginForm(
          isSubmitting: loginState.isSubmitting,
          onSubmitted: ref.read(webLoginControllerProvider.notifier).login,
        ),
      ),
    );
  }
}

// lib/features/login/presentation/pages/login_page.dart
import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/core/presentation/controllers/controllers.dart';
import 'package:celta_dash/features/login/presentation/controllers/controllers.dart';
import 'package:celta_dash/features/login/presentation/pages/components/components.dart';
import 'package:celta_dash/ui/helpers/helpers.dart';
import 'package:celta_dash/utils/constants/constants.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enterpriseController = useTextEditingController();
    final userController = useTextEditingController();
    final passwordController = useTextEditingController();

    final enterpriseFocusNode = useFocusNode();
    final userFocusNode = useFocusNode();
    final passwordFocusNode = useFocusNode();

    final formKey = useMemoized(() => GlobalKey<FormState>());

    // Prefill enterprise and user from saved ActiveEcParamsStateController or EnterpriseBuilder
    final activeEcParamsAsync = ref.watch(
      activeEcParamsStateControllerProvider,
    );
    useEffect(() {
      activeEcParamsAsync.whenData((params) {
        //TODO change the enterprise text
      });
      return null;
    }, [activeEcParamsAsync]);

    ref.listen(loginControllerProvider, (p, n) {
      n.showAlertDialogOnError(context);
    });

    final loginState = ref.watch(loginControllerProvider);
    final isLoading = loginState.isLoading;

    Future<void> submitLogin() async {
      if (formKey.currentState?.validate() != true) return;

      final success = await ref
          .read(loginControllerProvider.notifier)
          .login(
            enterpriseName: enterpriseController.text,
            user: userController.text,
            password: passwordController.text,
          );

      if (success && context.mounted) {
        Get.offAllNamed(PageRoutes.home); //TODO change this navigation
      }
    }

    return BaseScaffold(
      body: ResponsiveCenter(
        maxContentWidth: Breakpoint.tablet,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizes.p16),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                gapH32,
                GestureDetector(
                  onLongPress: () => Get.toNamed(PageRoutes.webLogin),
                  //TODO update to the new logo
                  child: Image.asset(
                    'lib/ui/assets/images/logoCeltaTransparente.png',
                    height: MediaQuery.sizeOf(context).height * 0.25,
                  ),
                ),
                gapH24,
                EnterpriseField(
                  controller: enterpriseController,
                  focusNode: enterpriseFocusNode,
                  nextFocusNode: userFocusNode,
                ),
                gapH16,
                UserField(
                  controller: userController,
                  focusNode: userFocusNode,
                  nextFocusNode: passwordFocusNode,
                ),
                gapH16,
                PasswordField(
                  controller: passwordController,
                  focusNode: passwordFocusNode,
                  onSubmitted: submitLogin,
                ),
                gapH24,
                PrimaryButton(
                  text: 'Entrar'.hardcoded,
                  isLoading: isLoading,
                  onPressed: submitLogin,
                ),
                gapH32,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

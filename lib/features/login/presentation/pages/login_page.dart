// lib/features/login/presentation/pages/login_page.dart
import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/login/presentation/controllers/controllers.dart';
import 'package:celta_dash/features/login/presentation/pages/components/components.dart';
import 'package:celta_dash/routing/routing.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
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

    final loginPrefill = ref.watch(loginPrefillControllerProvider);
    useEffect(() {
      loginPrefill.whenData((prefill) {
        if (enterpriseController.text.isEmpty &&
            prefill.enterpriseName != null) {
          enterpriseController.text = prefill.enterpriseName!;
        }
        if (userController.text.isEmpty && prefill.username != null) {
          userController.text = prefill.username!;
        }
      });
      return null;
    }, [loginPrefill]);

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
        context.goNamed(Routes.home.name);
      }
    }

    return BaseScaffold(
      isScrollable: false,
      body: ResponsiveCenter(
        maxContentWidth: Breakpoint.tablet,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizes.p16),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: .center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  gapH32,
                  GestureDetector(
                    onLongPress: () => context.pushNamed(Routes.webLogin.name),
                    child: const LogoWidget(
                      animationDuration: Duration(milliseconds: 3500),
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
      ),
    );
  }
}

import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/web_login/presentation/pages/components/components.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class WebLoginForm extends HookWidget {
  final bool isSubmitting;
  final Future<void> Function({required String email, required String password})
  onSubmitted;

  const WebLoginForm({
    super.key,
    required this.isSubmitting,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final emailFocusNode = useFocusNode();
    final passwordFocusNode = useFocusNode();

    Future<void> submit() async {
      if (formKey.currentState?.validate() != true) return;
      await onSubmitted(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
    }

    return ResponsiveCenter(
      maxContentWidth: Breakpoint.tablet,
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: Sizes.p16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const LogoWidget(),
              gapH24,
              WebLoginEmailField(
                controller: emailController,
                focusNode: emailFocusNode,
                nextFocusNode: passwordFocusNode,
              ),
              gapH16,
              WebLoginPasswordField(
                controller: passwordController,
                focusNode: passwordFocusNode,
                onSubmitted: submit,
              ),
              gapH24,
              PrimaryButton(
                text: 'Entrar'.hardcoded,
                isLoading: isSubmitting,
                onPressed: submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

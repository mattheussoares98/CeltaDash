import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/core/validators/validators.dart';
import 'package:celta_dash/exceptions/exceptions.dart';
import 'package:celta_dash/features/web_enterprises/domain/domain.dart';
import 'package:celta_dash/features/web_enterprises/presentation/controllers/controllers.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CreateEnterpriseForm extends HookConsumerWidget {
  const CreateEnterpriseForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final nameController = useTextEditingController();
    final urlController = useTextEditingController();
    final userController = useTextEditingController();
    final passwordController = useTextEditingController();
    final urlFocus = useFocusNode();
    final userFocus = useFocusNode();
    final passwordFocus = useFocusNode();
    final showPassword = useState(false);
    final isSaving = useState(false);

    Future<void> save() async {
      if (formKey.currentState?.validate() != true) return;
      isSaving.value = true;
      try {
        await ref
            .read(remoteEnterprisesControllerProvider.notifier)
            .createEnterprise(
              CreateWebEnterpriseParams(
                baseUrl: urlController.text,
                enterpriseName: nameController.text,
                user: userController.text,
                password: passwordController.text,
              ),
            );
        if (context.mounted) context.pop();
      } catch (error) {
        showToastMessage(parseErrorMessage(error), type: ToastType.error);
      } finally {
        isSaving.value = false;
      }
    }

    return Form(
      key: formKey,
      child: ListView(
        padding: const EdgeInsets.all(Sizes.p16),
        children: [
          BaseText.titleLarge('Nova empresa'.hardcoded),
          gapH24,
          BaseTextFormField(
            enabled: !isSaving.value,
            controller: nameController,
            labelText: 'Nome da empresa'.hardcoded,
            onFieldSubmitted: (_) => urlFocus.requestFocus(),
            validator: FormValidators.compose([
              NonEmptyValidator(),
              MinLengthValidator(2),
            ]),
          ),
          gapH12,
          BaseTextFormField(
            enabled: !isSaving.value,
            controller: urlController,
            labelText: 'URL'.hardcoded,
            keyboardType: TextInputType.url,
            focusNode: urlFocus,
            onFieldSubmitted: (_) => userFocus.requestFocus(),
            validator: FormValidators.compose([UrlValidator()]),
          ),
          gapH12,
          BaseTextFormField(
            enabled: !isSaving.value,
            controller: userController,
            labelText: 'Usuário BS'.hardcoded,
            focusNode: userFocus,
            onFieldSubmitted: (_) => passwordFocus.requestFocus(),
            validator: FormValidators.compose([NonEmptyValidator()]),
          ),
          gapH12,
          BaseTextFormField(
            enabled: !isSaving.value,
            controller: passwordController,
            labelText: 'Senha BS'.hardcoded,
            focusNode: passwordFocus,
            onFieldSubmitted: (_) => save(),
            obscureText: !showPassword.value,
            validator: FormValidators.compose([NonEmptyValidator()]),
            suffixIcon: IconButton(
              onPressed: () => showPassword.value = !showPassword.value,
              icon: PlatformIcon(
                materialIcon: showPassword.value
                    ? Icons.visibility_off
                    : Icons.visibility,
                cupertinoIcon: showPassword.value
                    ? CupertinoIcons.eye_slash
                    : CupertinoIcons.eye,
              ),
            ),
          ),
          gapH24,
          PrimaryButton(
            text: 'Adicionar'.hardcoded,
            isLoading: isSaving.value,
            onPressed: save,
          ),
        ],
      ),
    );
  }
}

import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/enterprises_manager/domain/domain.dart';
import 'package:celta_dash/features/enterprises_manager/presentation/controllers/controllers.dart';
import 'package:celta_dash/features/login/presentation/pages/pages.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddEnterpriseForm extends HookConsumerWidget {
  const AddEnterpriseForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enterpriseController = useTextEditingController();
    final userController = useTextEditingController();
    final passwordController = useTextEditingController();
    final enterpriseFocusNode = useFocusNode();
    final userFocusNode = useFocusNode();
    final passwordFocusNode = useFocusNode();
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final isLoading = ref.watch(
      enterprisesManagerControllerProvider.select(
        (s) => s.value?.isProcessing == true,
      ),
    );

    Future<void> submit() async {
      if (formKey.currentState?.validate() != true) return;
      final success = await ref
          .read(enterprisesManagerControllerProvider.notifier)
          .addEnterprise(
            AddEnterpriseParams(
              enterpriseName: enterpriseController.text,
              user: userController.text,
              password: passwordController.text,
            ),
          );
      if (!success) return;

      enterpriseController.clear();
      userController.clear();
      passwordController.clear();
      showToastMessage('Empresa adicionada'.hardcoded);
    }

    return Form(
      key: formKey,
      child: ExpansionTile(
        title: BaseText.titleMedium('Adicionar nova empresa'.hardcoded),
        children: [
          EnterpriseField(
            controller: enterpriseController,
            focusNode: enterpriseFocusNode,
            nextFocusNode: userFocusNode,
          ),
          gapH12,
          UserField(
            controller: userController,
            focusNode: userFocusNode,
            nextFocusNode: passwordFocusNode,
          ),
          gapH12,
          PasswordField(
            controller: passwordController,
            focusNode: passwordFocusNode,
            onSubmitted: submit,
          ),
          gapH16,
          PrimaryButton(
            text: 'Adicionar'.hardcoded,
            isLoading: isLoading,
            onPressed: submit,
          ),
        ],
      ),
    );
  }
}

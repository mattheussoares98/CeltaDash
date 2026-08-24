import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/core/validators/validators.dart';
import 'package:celta_dash/exceptions/exceptions.dart';
import 'package:celta_dash/features/web_enterprises/presentation/controllers/controllers.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EnterpriseEditor extends HookConsumerWidget {
  final FirebaseEnterpriseEntity enterprise;

  const EnterpriseEditor({super.key, required this.enterprise});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final urlController = useTextEditingController(text: enterprise.baseUrl);
    final subEnterprises = useState(
      List<FirebaseSubEnterpriseEntity>.of(
        enterprise.firebaseSubEnterprises ?? const [],
      ),
    );
    final isSaving = useState(false);

    Future<void> save() async {
      if (formKey.currentState?.validate() != true) return;
      isSaving.value = true;
      try {
        await ref
            .read(remoteEnterprisesControllerProvider.notifier)
            .updateEnterprise(
              enterprise.copyWith(
                baseUrl: urlController.text.trim(),
                firebaseSubEnterprises: subEnterprises.value,
              ),
            );
        if (context.mounted) context.pop();
      } catch (error) {
        showToastMessage(parseErrorMessage(error), type: .error);
      } finally {
        isSaving.value = false;
      }
    }

    return Form(
      key: formKey,
      child: ListView(
        padding: const EdgeInsets.all(Sizes.p16),
        children: [
          BaseText.titleLarge(
            enterprise.enterpriseName?.toUpperCase() ??
                'Editar empresa'.hardcoded,
          ),
          gapH24,
          BaseTextFormField(
            controller: urlController,
            labelText: 'URL'.hardcoded,
            enabled: !isSaving.value,
            hintText: 'https://empresa.com.br'.hardcoded,
            keyboardType: TextInputType.url,
            validator: FormValidators.compose([UrlValidator()]),
          ),
          gapH24,
          BaseText.title('CNPJs'.hardcoded),
          gapH8,
          if (subEnterprises.value.isEmpty)
            BaseText('Nenhum CNPJ encontrado'.hardcoded)
          else
            for (var index = 0; index < subEnterprises.value.length; index++)
              Builder(
                builder: (context) {
                  final subEnterprise = subEnterprises.value[index];

                  return BaseSwitch(
                    title: Column(
                      crossAxisAlignment: .start,
                      children: [
                        BaseText.title(
                          "${subEnterprise.personalizedCode} - ${subEnterprise.name}",
                        ),
                        if (subEnterprise.cnpj?.isNotEmpty ?? false)
                          BaseText(subEnterprise.cnpj!),
                      ],
                    ),
                    value: subEnterprises.value[index].enabled ?? false,
                    onChanged: isSaving.value
                        ? null
                        : (enabled) {
                            final updated = [...subEnterprises.value];
                            updated[index] = updated[index].copyWith(
                              enabled: enabled,
                            );
                            subEnterprises.value = updated;
                          },
                  );
                },
              ),
          gapH24,
          PrimaryButton(
            text: 'Salvar'.hardcoded,
            isLoading: isSaving.value,
            onPressed: save,
          ),
        ],
      ),
    );
  }
}

import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/core/validators/validators.dart';
import 'package:celta_dash/exceptions/exceptions.dart';
import 'package:celta_dash/features/home/presentation/controllers/controllers.dart';
import 'package:celta_dash/features/home/providers.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MonthlyGoalEditor extends HookConsumerWidget {
  const MonthlyGoalEditor({super.key, required this.enterpriseId});

  final int enterpriseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = monthlyGoalComparisonControllerProvider(enterpriseId);
    final selectedDate = ref.watch(
      homeControllerProvider.select((state) => state.value?.selectedDate),
    );
    final now = ref.watch(resumeCurrentDateProvider);
    final isEditing = useState(false);
    final isSaving = useState(false);
    final controller = useTextEditingController();
    final focusNode = useFocusNode();
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final canEdit =
        selectedDate != null &&
        !DateTime(
          selectedDate.year,
          selectedDate.month,
        ).isBefore(DateTime(now.year, now.month));

    void closeEditor() {
      controller.clear();
      isEditing.value = false;
    }

    Future<void> save() async {
      if (formKey.currentState?.validate() != true) return;
      final value = controller.text.toDouble();
      if (value == null) return;

      isSaving.value = true;
      try {
        await ref.read(provider.notifier).updateMonthlyGoal(value);
        if (!context.mounted) return;
        closeEditor();
        showToastMessage('Meta atualizada'.hardcoded);
      } catch (error) {
        if (!context.mounted) return;
        showToastMessage(parseErrorMessage(error), type: ToastType.error);
      } finally {
        if (context.mounted) isSaving.value = false;
      }
    }

    if (!isEditing.value) {
      return Center(
        child: PrimaryTextButton(
          text: 'Editar meta'.hardcoded,
          onPressed: canEdit
              ? () {
                  isEditing.value = true;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (context.mounted) focusNode.requestFocus();
                  });
                }
              : null,
          platformIcon: const PlatformIcon(
            cupertinoIcon: CupertinoIcons.pencil,
            materialIcon: Icons.edit,
          ),
        ),
      );
    }

    return Form(
      key: formKey,
      child: Column(
        children: [
          Row(
            children: [
              BaseIconButton(
                onPressed: isSaving.value ? null : closeEditor,
                platformIcon: const PlatformIcon(
                  cupertinoIcon: CupertinoIcons.xmark,
                  materialIcon: Icons.close,
                  color: Colors.red,
                ),
              ),
              Expanded(
                child: BaseTextFormField(
                  controller: controller,
                  focusNode: focusNode,
                  labelText: 'Meta (R\$)'.hardcoded,
                  onFieldSubmitted: (_) => save(),
                  autovalidateMode: AutovalidateMode.onUserInteractionIfError,
                  validator: FormValidators.compose([
                    NonEmptyValidator(),
                    NumberValidator(allowDecimal: true),
                  ]),
                  keyboardType: const TextInputType.numberWithOptions(
                    signed: true,
                  ),
                ),
              ),
              BaseIconButton(
                onPressed: isSaving.value ? null : save,
                platformIcon: const PlatformIcon(
                  cupertinoIcon: CupertinoIcons.check_mark,
                  materialIcon: Icons.save,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

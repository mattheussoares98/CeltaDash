// lib/features/home/presentation/pages/personalized/personalized_page.dart
import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'components/components.dart';

class PersonalizedPage extends HookConsumerWidget {
  const PersonalizedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parametersController = useMemoized(() => ExpansibleController());
    final enterprisesController = useMemoized(() => ExpansibleController());
    final periodsController = useMemoized(() => ExpansibleController());
    final categoriesController = useMemoized(() => ExpansibleController());

    void collapseAll(bool collapseParameters) {
      if (enterprisesController.isExpanded) enterprisesController.collapse();
      if (periodsController.isExpanded) periodsController.collapse();
      if (categoriesController.isExpanded) categoriesController.collapse();
      if (collapseParameters && parametersController.isExpanded) {
        parametersController.collapse();
      }
    }

    ref.listen(
      personalizedControllerProvider.select((s) => s.validationError),
      (previous, next) {
        if (next != null) {
          showToastMessage(next, type: .error);
        }
      },
    );

    final isGenerating = ref.watch(
      personalizedControllerProvider.select((s) => s.isGenerating),
    );
    final hasValidDateRange = ref.watch(
      personalizedControllerProvider.select((s) => s.hasValidDateRange),
    );

    return BaseScaffold(
      isScrollable: false,
      usePadding: false,
      appBar: BaseAppBar(title: 'Personalizado'.hardcoded),
      body: LayoutBuilder(
        builder: (context, constraints) => Column(
          children: [
            IgnorePointer(
              ignoring: isGenerating,
              child: Card(
                elevation: 4,
                margin: const EdgeInsets.fromLTRB(
                  Sizes.p4,
                  Sizes.p8,
                  Sizes.p8,
                  Sizes.p8,
                ),
                child: ExpansionTile(
                  controller: parametersController,
                  initiallyExpanded: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Sizes.p8),
                  ),
                  dense: true,
                  title: BaseText.titleMedium(
                    'Parâmetros'.hardcoded,
                    fontWeight: FontWeight.bold,
                  ),
                  childrenPadding: const EdgeInsets.symmetric(
                    horizontal: Sizes.p8,
                    vertical: Sizes.p4,
                  ),
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: (constraints.maxHeight - 120).clamp(
                          //!return always a number between 0 and constraints.maxHeight * 0.7
                          0,
                          constraints.maxHeight * 0.7,
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            PersonalizedDateSelector(
                              onDateRangeCompleted: () {
                                if (!enterprisesController.isExpanded) {
                                  enterprisesController.expand();
                                }
                              },
                            ),
                            if (hasValidDateRange) ...[
                              gapH8,
                              PersonalizedEnterprisesTile(
                                controller: enterprisesController,
                                onEnterpriseSelected: () {
                                  collapseAll(false);
                                  if (!periodsController.isExpanded) {
                                    periodsController.expand();
                                  }
                                },
                              ),
                              gapH8,
                              PersonalizedPeriodTile(
                                controller: periodsController,
                                onPeriodSelected: () {
                                  collapseAll(false);
                                  if (!categoriesController.isExpanded) {
                                    categoriesController.expand();
                                  }
                                },
                              ),
                              gapH8,
                              PersonalizedCategoryTile(
                                controller: categoriesController,
                              ),
                              gapH8,
                              PersonalizedGenerateButton(
                                onGenerateSuccess: () => collapseAll(true),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Expanded(child: PersonalizedTable()),
          ],
        ),
      ),
    );
  }
}

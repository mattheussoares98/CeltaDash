import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../helpers/helpers.dart';
import '../../mixins/mixins.dart';
import '../pages.dart';
import 'components/components.dart';

class PersonalizedPage extends StatefulWidget {
  final PersonalizedPresenter presenter;
  const PersonalizedPage({super.key, required this.presenter});

  @override
  State<PersonalizedPage> createState() => _PersonalizedPageState();
}

class _PersonalizedPageState extends State<PersonalizedPage>
    with UIErrorManager {
  StreamSubscription? mainErrorSubscription;
  DateTimeRange? selectedDateRange;
  final parametersController = ExpansibleController();
  final enterprisesController = ExpansibleController();
  final periodsController = ExpansibleController();
  final categoriesController = ExpansibleController();

  @override
  void dispose() {
    super.dispose();
    mainErrorSubscription?.cancel();
    parametersController.dispose();
    enterprisesController.dispose();
    periodsController.dispose();
    categoriesController.dispose();
  }

  @override
  void initState() {
    super.initState();
    mainErrorSubscription =
        handleMainError(context, widget.presenter.mainErrorStream);
  }

  void collapseAll(bool collapseParameters) {
    enterprisesController.collapse();
    periodsController.collapse();
    categoriesController.collapse();
    if (collapseParameters) {
      parametersController.collapse();
    }
  }

  @override
  Widget build(BuildContext context) {
    Get.put<PersonalizedPresenter>(widget.presenter);

    return Scaffold(
      body: StreamBuilder(
          stream: widget.presenter.isLoadingStream,
          builder: (context, loadingSnap) {
            return Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Obx(() {
                        final startDate =
                            widget.presenter.currentSelectedParams?.startDate;
                        final endDate =
                            widget.presenter.currentSelectedParams?.endDate;

                        return Column(
                          // crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Card(
                              elevation: 10,
                              margin: const EdgeInsets.fromLTRB(4, 8, 8, 20),
                              child: ExpansionTile(
                                controller: parametersController,
                                initiallyExpanded: true,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                dense: true,
                                title: Text(
                                  R.string.parameters,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                ),
                                childrenPadding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                children: [
                                  SelectPeriod(
                                    enterprisesController:
                                        enterprisesController,
                                    isLoading: loadingSnap.data,
                                  ),
                                  const SizedBox(height: 4),
                                  if (startDate != null && endDate != null) ...[
                                    Enterprises(
                                      enterprisesController:
                                          enterprisesController,
                                      periodsController: periodsController,
                                      collapseAll: collapseAll,
                                    ),
                                    const SizedBox(height: 4),
                                    PeriodGrouping(
                                      periodsController: periodsController,
                                      categoriesController:
                                          categoriesController,
                                      collapseAll: collapseAll,
                                    ),
                                    const SizedBox(height: 4),
                                    CategoryGrouping(
                                      categoriesController:
                                          categoriesController,
                                      collapseAll: collapseAll,
                                    ),
                                    const SizedBox(height: 4),
                                    GenerateButton(
                                      collapseAll: collapseAll,
                                      isLoading: loadingSnap.data,
                                    ),
                                  ]
                                ],
                              ),
                            ),
                            // const PersonalizedPieChart(),
                          ],
                        );
                      }),
                    ),
                    const PersonalizedTable(),
                  ],
                ),
                if (loadingSnap.data == true)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withAlpha(0),
                    ),
                  ),
              ],
            );
          }),
    );
  }
}

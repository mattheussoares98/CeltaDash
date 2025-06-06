import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/components.dart';
import '../../mixins/mixins.dart';
import '../pages.dart';
import 'components/components.dart';

class CompareDaysPage extends StatefulWidget {
  const CompareDaysPage({super.key});

  @override
  State<CompareDaysPage> createState() => _ProfitabilityPageState();
}

class _ProfitabilityPageState extends State<CompareDaysPage>
    with UIErrorManager {
  StreamSubscription? mainErrorSubscription;
  static final _now = DateTime.now();
  final firstDay = DateTime(_now.year, _now.month, _now.day - 1);
  final secondDay = DateTime(_now.year, _now.month, _now.day);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        HomePresenter homePresenter = Get.find();
        CompareDaysPresenter compareDaysPresenter = Get.find();

        await compareDaysPresenter.getSales(
          firstDay: firstDay,
          secondDay: secondDay,
          homePresenter: homePresenter,
        );
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    mainErrorSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Get.find();
    CompareDaysPresenter compareDaysPresenter = Get.find();

    mainErrorSubscription?.cancel();
    mainErrorSubscription =
        handleMainError(context, compareDaysPresenter.mainErrorStream);

    return StreamBuilder(
        stream: compareDaysPresenter.isLoadingStream,
        builder: (context, loadingSnap) {
          return Scaffold(
            appBar: DefaultAppBar(
              isLoading: loadingSnap.data == true,
              onChangeEnterprise: (_) async {
                await compareDaysPresenter.getSales(
                  firstDay: compareDaysPresenter.selectedFirstDay ?? firstDay,
                  secondDay:
                      compareDaysPresenter.selectedSecondDay ?? secondDay,
                  homePresenter: homePresenter,
                );
              },
              showDatePicker: false,
            ),
            body: SafeArea(
              child: Obx(() {
                Get.put<CompareDaysPresenter>(compareDaysPresenter);

                final saleMovements = compareDaysPresenter.saleMovements;

                if (saleMovements == null || saleMovements.isEmpty) {
                  return EmptySales(isLoading: loadingSnap.data == true);
                }

                return Column(
                  children: [
                    ChangeDatesButtons(
                      firstDay: compareDaysPresenter.selectedFirstDay ??
                          firstDay,
                      secondDay:
                          compareDaysPresenter.selectedSecondDay ??
                              secondDay,
                    ),
                    if (compareDaysPresenter.selectedFirstDay != null &&
                        compareDaysPresenter.selectedSecondDay != null)
                      Expanded(
                        child: Column(
                          children: [
                            CompareTable(
                              firstDay: compareDaysPresenter
                                      .selectedFirstDay ??
                                  firstDay,
                              secondDay: compareDaysPresenter
                                      .selectedSecondDay ??
                                  secondDay,
                            ),
                            Result(
                              firstDay: compareDaysPresenter
                                      .selectedFirstDay ??
                                  firstDay,
                              secondDay: compareDaysPresenter
                                      .selectedSecondDay ??
                                  secondDay,
                            ),
                          ],
                        ),
                      ),
                  ],
                );
              }),
            ),
          );
        });
  }
}

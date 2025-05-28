import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/components.dart';
import '../../mixins/mixins.dart';
import '../pages.dart';
import 'components/components.dart';

class CompareDaysPage extends StatefulWidget {
  final CompareDaysPresenter presenter;
  const CompareDaysPage({super.key, required this.presenter});

  @override
  State<CompareDaysPage> createState() => _ProfitabilityPageState();
}

class _ProfitabilityPageState extends State<CompareDaysPage>
    with UIErrorManager, LoadingManager {
  StreamSubscription? loadingSubscription;
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

        await widget.presenter.getSales(
          firstDay: firstDay,
          secondDay: secondDay,
          homePresenter: homePresenter,
        );
        Future.delayed(Duration.zero, () {
          setState(() {});
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Get.find();
    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();

    loadingSubscription =
        handleLoading(context, widget.presenter.isLoadingStream);
    mainErrorSubscription =
        handleMainError(context, widget.presenter.mainErrorStream);

    return Scaffold(
      appBar: DefaultAppBar(
        onChangeEnterprise: (_) async {
          await widget.presenter.getSales(
            firstDay: widget.presenter.selectedFirstDay ?? firstDay,
            secondDay: widget.presenter.selectedSecondDay ?? secondDay,
            homePresenter: homePresenter,
          );
        },
        showDatePicker: false,
      ),
      body: SafeArea(
        child: Obx(() {
          Get.put<CompareDaysPresenter>(widget.presenter);

          final saleMovements = widget.presenter.saleMovements;

          return StreamBuilder<bool>(
              stream: homePresenter.updateScreenStream,
              builder: (context, snapshot) {
                if ((saleMovements == null || saleMovements.isEmpty) ||
                    snapshot.data == true) {
                  return EmptySales(isLoading: false);
                }
                return Opacity(
                  opacity: snapshot.data == true ? 0 : 1,
                  child: Column(
                    children: [
                      ChangeDatesButtons(
                        firstDay: widget.presenter.selectedFirstDay ?? firstDay,
                        secondDay:
                            widget.presenter.selectedSecondDay ?? secondDay,
                      ),
                      if (widget.presenter.selectedFirstDay != null &&
                          widget.presenter.selectedSecondDay != null)
                        Expanded(
                          child: Column(
                            children: [
                              CompareTable(
                                firstDay: widget.presenter.selectedFirstDay ??
                                    firstDay,
                                secondDay: widget.presenter.selectedSecondDay ??
                                    secondDay,
                              ),
                              Result(
                                firstDay: widget.presenter.selectedFirstDay ??
                                    firstDay,
                                secondDay: widget.presenter.selectedSecondDay ??
                                    secondDay,
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                );
              });
        }),
      ),
    );
  }
}

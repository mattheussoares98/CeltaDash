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
  static final _now = DateTime.now();
  final firstDay = DateTime(_now.year, _now.month, _now.day - 1);
  final secondDay = DateTime(_now.year, _now.month, _now.day);

  StreamSubscription? loadingSubscription;
  StreamSubscription? mainErrorSubscription;

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
            firstDay: firstDay,
            secondDay: secondDay,
            homePresenter: homePresenter,
          );
        },
        showDatePicker: false,
      ),
      body: Obx(() {
        Get.put<CompareDaysPresenter>(widget.presenter);

        final saleMovements = widget.presenter.saleMovements;

        return StreamBuilder<bool>(
            stream: homePresenter.updateScreenStream,
            builder: (context, snapshot) {
              return Opacity(
                opacity: snapshot.data == true ? 0 : 1,
                child: Column(
                  children: [
                    ChangeDatesButtons(
                      firstDay: firstDay,
                      secondDay: secondDay,
                    ),
                    if (saleMovements != null)
                      CompareTable(firstDay: firstDay, secondDay: secondDay),
                    if (saleMovements != null)
                      Result(firstDay: firstDay, secondDay: secondDay),
                  ],
                ),
              );
            });
      }),
    );
  }
}

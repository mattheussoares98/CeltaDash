import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/components.dart';
import '../../helpers/helpers.dart';
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

  bool needRefresh = false;

  @override
  Widget build(BuildContext context) {
    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();

    loadingSubscription =
        handleLoading(context, widget.presenter.isLoadingStream);
    mainErrorSubscription =
        handleMainError(context, widget.presenter.mainErrorStream);

    return Scaffold(
      appBar: DefaultAppBar(
        onChangeEnterprise: (_) {},
        showDatePicker: false,
      ),
      body: Obx(() {
        Get.put<CompareDaysPresenter>(widget.presenter);

        if (needRefresh) {
          Future.delayed(Duration.zero, () {
            setState(() {});
          });
          needRefresh = false;
        }
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(R.string.compareDays),
            ),
            ChangeDatesButtons(
              firstDay: firstDay,
              secondDay: secondDay,
              updateDate: (date) {
                setState(() {});
              },
              changeNeedUpdateScreen: () {
                setState(() {
                  needRefresh = true;
                });
              },
            ),
            const SizedBox(height: 10),
            if (widget.presenter.saleMovements != null) CompareTable(),
            if (widget.presenter.saleMovements != null)
              Result(firstDay: firstDay, secondDay: secondDay),
            // Expanded(
            //   child: Column(
            //     children: [
            //       Result(firstDay: firstDay, secondDay: secondDay),
            //     ],
            //   ),
            // ),
          ],
        );
      }),
    );
  }
}

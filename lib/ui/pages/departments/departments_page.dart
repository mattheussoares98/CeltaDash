import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../../mixins/mixins.dart';
import '../pages.dart';
import 'components/components.dart';

class DepartmentsPage extends StatefulWidget {
  final DepartmentsPresenter departmentsPresenter;
  const DepartmentsPage({
    super.key,
    required this.departmentsPresenter,
  });

  @override
  State<DepartmentsPage> createState() => _DepartmentsPageState();
}

class _DepartmentsPageState extends State<DepartmentsPage>
    with LoadingManager, UIErrorManager {
  bool selectedMonth = false;
  bool needUpdateScreen = false;
  int selectedPageIndex = 0;
  StreamSubscription? loadingSubscription;
  StreamSubscription? mainErrorSubscription;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        HomePresenter homePresenter = Get.find();

        await widget.departmentsPresenter.getSales(homePresenter);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
  }

  void updateSelectedMonth(bool value) {
    setState(() {
      selectedMonth = value;
    });
    needUpdateScreen = true;
  }

  bool filter(SaleMovementViewModel sale, HomePresenter homePresenter) {
    final selectedDate = homePresenter.selectedDate;

    return (selectedMonth ? true : sale.Date?.day == selectedDate.day) &&
        sale.Date?.month == selectedDate.month &&
        sale.Date?.year == selectedDate.year;
  }

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Get.find();

    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
    loadingSubscription =
        handleLoading(context, widget.departmentsPresenter.isLoadingStream);
    mainErrorSubscription =
        handleMainError(context, widget.departmentsPresenter.mainErrorStream);

    return Scaffold(
      appBar: DefaultAppBar(
        onChangeDateOrEnterprise: (_) async {
          needUpdateScreen = true;
          await widget.departmentsPresenter.getSales(homePresenter);
        },
      ),
      body: Obx(() {
        if (needUpdateScreen) {
          Future.delayed(Duration.zero, () {
            setState(() {});
          });
          needUpdateScreen = false;
        }

        final saleMovements = widget.departmentsPresenter.saleMovements
            ?.where((e) => filter(e, homePresenter))
            .toList();

        if (saleMovements == null || saleMovements.isEmpty) {
          return Center(
            child: ElevatedButton(
              onPressed: () async {
                await widget.departmentsPresenter.getSales(homePresenter);
              },
              child: Text(R.string.searchAgain),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SelectDayOrMonth(updateSelectedMonth: updateSelectedMonth),
            ),
            //TODO analyse to create two pages and navigate between them
            if (selectedPageIndex == 0)
              Departments(saleMovements: saleMovements),
            if (selectedPageIndex == 1) Sections(saleMovements: saleMovements),
          ],
        );
      }),
      bottomNavigationBar: BottomNavigation(
        selectedPageIndex: selectedPageIndex,
        updateSelectedPageIndex: (value) {
          if (value == selectedPageIndex) return;
          setState(() {
            selectedPageIndex = value;
          });
          needUpdateScreen = true;
        },
      ),
    );
  }
}

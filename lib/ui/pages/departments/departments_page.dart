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
  int selectedPageIndex = 0;
  StreamSubscription? loadingSubscription;
  StreamSubscription? mainErrorSubscription;
  final pageController = PageController();

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
    pageController.dispose();
  }

  void updateSelectedMonth(bool value) {
    setState(() {
      selectedMonth = value;
    });
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
        onChangeEnterprise: (_) async {
          await widget.departmentsPresenter.getSales(homePresenter);
        },
        onChangeDate: (_) async {
          await widget.departmentsPresenter.getSales(homePresenter);
        },
        onTapRefresh: () async {
          await widget.departmentsPresenter.getSales(
            homePresenter,
            forceRefresh: true,
          );
        },
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SelectDayOrMonth(updateSelectedMonth: updateSelectedMonth),
          ),
          Obx(() {
            final saleMovements = widget.departmentsPresenter.saleMovements
                ?.filteredSales(
                  enterprise: homePresenter.selectedEnterprise,
                )
                .map((e) => e.toViewModel())
                .where((e) => filter(e, homePresenter))
                .toList();

            if (saleMovements == null || saleMovements.isEmpty) {
              return SizedBox.shrink();
            }

            return StreamBuilder<bool>(
                stream: homePresenter.updateScreenStream,
                builder: (context, snapshot) {
                  return Expanded(
                    child: Opacity(
                      opacity: snapshot.data == true ? 0 : 1,
                      child: PageView(
                        controller: pageController,
                        onPageChanged: (value) {
                          setState(() {
                            selectedPageIndex = value;
                          });
                        },
                        children: [
                          Departments(saleMovements: saleMovements),
                          Sections(saleMovements: saleMovements),
                        ],
                      ),
                    ),
                  );
                });
          }),
        ],
      ),
      bottomNavigationBar: BottomNavigation(
        selectedPageIndex: selectedPageIndex,
        updateSelectedPageIndex: (value) {
          setState(() {
            selectedPageIndex = value;
          });
          pageController.animateToPage(
            value,
            duration: Duration(milliseconds: 300),
            curve: Curves.bounceOut,
          );
        },
      ),
    );
  }
}

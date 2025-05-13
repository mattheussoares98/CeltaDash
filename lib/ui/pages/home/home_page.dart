import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../main/factories/factories.dart';
import '../../../ui/mixins/mixins.dart';
import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with LoadingManager, UIErrorManager {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        HomePresenter homePresenter = Get.find();

        await homePresenter.getBsEnterprises(showBsErrorMessage: (error) {
          snackBarMessage(context, error, Colors.red);
        });

        reloadData();
      }
    });
  }

  Future<void> reloadData({
    bool? forceRefresh,
  }) async {
    ProductsPresenter productsPresenter = Get.find();
    HomePresenter homePresenter = Get.find();
    SalesPresenter salesPresenter = Get.find();
    ResumePresenter resumePresenter = Get.find();
    PaymentTypePresenter paymentTypePresenter = Get.find();
    DepartmentsPresenter departmentsPresenter = Get.find();

    homePresenter.reloadAllData(
      salesPresenter,
      resumePresenter,
      paymentTypePresenter,
      productsPresenter,
      departmentsPresenter,
      forceRefresh: forceRefresh,
    );
  }

  final pages = <Widget>[
    makeResumePage(),
    // makeIndicatorsPage(),//Dont make sense use this pages because is similar salesPage
    makeSalesPage(),
    makeProductsPage(),
    // makeTeamPage(),
  ];

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Get.find();
    ResumePresenter resumePresenter = Get.find();
    SalesPresenter salesPresenter = Get.find();
    ProductsPresenter productsPresenter = Get.find();

    return StreamBuilder<int>(
      stream: homePresenter.currentPageIndexStream,
      builder: (context, currentIndex) {
        return StreamBuilder<bool>(
            stream: productsPresenter.isLoadingStream,
            builder: (context, isLoadingProducts) {
              return StreamBuilder<bool>(
                  stream: resumePresenter.isLoadingStream,
                  builder: (context, isLoadingResume) {
                    return StreamBuilder<bool>(
                        stream: salesPresenter.isLoadingStream,
                        builder: (context, isLoadingSales) {
                          return Scaffold(
                            appBar: DefaultAppBar(
                              isLoading: (isLoadingSales.data == true &&
                                      currentIndex.data == 1) ||
                                  (isLoadingResume.data == true &&
                                      currentIndex.data == 0) ||
                                  (isLoadingProducts.data == true &&
                                      currentIndex.data == 2),
                              onChangeEnterprise: (_) {
                                reloadData(forceRefresh: true);
                              },
                              onChangeDate: (_) {
                                reloadData();
                              },
                              onTapRefresh: () {
                                reloadData(forceRefresh: true);
                              },
                            ),
                            body: pages[currentIndex.data ?? 0],
                            bottomNavigationBar: BottomNavBar(
                              currentIndex: currentIndex.data ?? 0,
                              onTap: homePresenter.updateSelectedIndex,
                              items: [
                                BottomNavItem(
                                  materialIcon: Icon(Icons.pie_chart),
                                  cupertinoIcon: Icon(CupertinoIcons.chart_pie),
                                  label: R.string.resume,
                                ),
                                BottomNavItem(
                                  materialIcon: Icon(Icons.monetization_on),
                                  cupertinoIcon:
                                      Icon(CupertinoIcons.money_dollar),
                                  label: R.string.sales,
                                ),
                                BottomNavItem(
                                  materialIcon:
                                      Icon(Icons.shopping_cart_rounded),
                                  cupertinoIcon: Icon(CupertinoIcons.cart),
                                  label: R.string.products,
                                ),
                                // BottomNavItem(
                                //   materialIcon: Icon(Icons.person_pin_sharp),
                                //   cupertinoIcon: Icon(CupertinoIcons.person_2),
                                //   label: R.string.team,
                                // ),
                                //TODO implement
                              ],
                            ),
                          );
                        });
                  });
            });
      },
    );
  }
}

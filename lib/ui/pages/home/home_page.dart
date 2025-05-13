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
  StreamSubscription? resumeLoadingSubscription;
  StreamSubscription? resumeMainErrorSubscription;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        HomePresenter homePresenter = Get.find();
        ResumePresenter resumePresenter = Get.find();
        SalesPresenter salesPresenter = Get.find();

        await homePresenter.getBsEnterprises(showBsErrorMessage: (error) {
          snackBarMessage(context, error, Colors.red);
        });

        reloadData(homePresenter, salesPresenter, resumePresenter);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    resumeLoadingSubscription?.cancel();
    resumeMainErrorSubscription?.cancel();
  }

  Future<void> reloadData(
    HomePresenter homePresenter,
    SalesPresenter salesPresenter,
    ResumePresenter resumePresenter, {
    bool? forceRefresh,
  }) async {
    resumePresenter.getSales(homePresenter, forceRefresh: forceRefresh);
    salesPresenter.getSales(
      homePresenter: homePresenter,
      resumePresenter: resumePresenter,
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

    resumeLoadingSubscription?.cancel();
    resumeMainErrorSubscription?.cancel();
    resumeLoadingSubscription = handleLoading(
      context,
      resumePresenter.isLoadingStream,
    );
    resumeMainErrorSubscription = handleMainError(
      context,
      resumePresenter.mainErrorStream,
    );

    return StreamBuilder<int>(
      stream: homePresenter.currentPageIndexStream,
      builder: (context, snapshot) {
        return Scaffold(
          appBar: DefaultAppBar(
            onChangeEnterprise: (changedEnterprise) async {
              reloadData(homePresenter, salesPresenter, resumePresenter);
            },
            onChangeDate: (newDate) async {
              reloadData(homePresenter, salesPresenter, resumePresenter);
            },
            onTapRefresh: () async {
              reloadData(
                homePresenter,
                salesPresenter,
                resumePresenter,
                forceRefresh: true,
              );
            },
          ),
          body: pages[snapshot.data ?? 0],
          bottomNavigationBar: BottomNavBar(
            currentIndex: snapshot.data ?? 0,
            onTap: homePresenter.updateSelectedIndex,
            items: [
              BottomNavItem(
                materialIcon: Icon(Icons.pie_chart),
                cupertinoIcon: Icon(CupertinoIcons.chart_pie),
                label: R.string.resume,
              ),
              BottomNavItem(
                materialIcon: Icon(Icons.monetization_on),
                cupertinoIcon: Icon(CupertinoIcons.money_dollar),
                label: R.string.sales,
              ),
              BottomNavItem(
                materialIcon: Icon(Icons.shopping_cart_rounded),
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
      },
    );
  }
}

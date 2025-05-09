import 'dart:async';

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

        await homePresenter.getBsEnterprises(showBsErrorMessage: (error) {
          snackBarMessage(context, error, Colors.red);
        });

        await resumePresenter.getSales(homePresenter);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    resumeLoadingSubscription?.cancel();
    resumeMainErrorSubscription?.cancel();
  }

  final pages = <Widget>[
    makeResumePage(),
    IndicatorsPage(),
    makeSalesPage(),
    ProductsPage(),
    makeTeamPage(),
  ];

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Get.find();
    ResumePresenter resumePresenter = Get.find();

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
          body: pages[snapshot.data ?? 0],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: snapshot.data ?? 0,
            onTap: homePresenter.updateSelectedIndex,
            type: BottomNavigationBarType.fixed,
            unselectedFontSize: 10,
            selectedFontSize: 12,
            selectedIconTheme: IconThemeData(
              size: 30,
              color: Theme.of(context).primaryColorDark,
            ),
            unselectedIconTheme: IconThemeData(
              size: 20,
              color: Theme.of(context).primaryColorLight,
            ),
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.pie_chart),
                label: R.string.resume,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart),
                label: R.string.indicators,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.monetization_on),
                label: R.string.sales,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart_rounded),
                label: R.string.products,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_pin_sharp),
                label: R.string.team,
              ),
            ],
          ),
        );
      },
    );
  }
}

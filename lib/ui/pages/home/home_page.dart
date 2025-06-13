import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../main/builders/builders.dart';
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

class _HomePageState extends State<HomePage> with UIErrorManager, RouteAware {
  StreamSubscription? mainErrorSubscription;
  bool loadedEnterprises = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        HomePresenter homePresenter = Get.find();
        ResumePresenter resumePresenter = Get.find();
        SalesPresenter salesPresenter = Get.find();
        ProductsPresenter productsPresenter = Get.find();
        homePresenter.updateSelectedIndex(0);
        await homePresenter.getBsEnterprises(
          docRef: FirebaseFirestore.instance.collection("enterprises").doc(
                EnterpriseBuilder.entity?.firebaseId,
              ),
          showBsErrorMessage: (error) {
            snackBarMessage(context, error, Colors.red);
          },
        );

        setState(() {
          loadedEnterprises = true;
        });

        homePresenter.reloadSales(
          resumePresenter,
          salesPresenter,
          productsPresenter,
        );
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    mainErrorSubscription?.cancel();
    final routeObserver = Get.find<RouteObserver<PageRoute>>();
    routeObserver.unsubscribe(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final routeObserver = Get.find<RouteObserver<PageRoute>>();
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void didPopNext() {
    debugPrint('Closed another page and returned to homePage');
    ResumePresenter resumePresenter = Get.find();
    HomePresenter homePresenter = Get.find();
    SalesPresenter salesPresenter = Get.find();
    ProductsPresenter productsPresenter = Get.find();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => homePresenter.reloadSales(
        resumePresenter,
        salesPresenter,
        productsPresenter,
      ),
    );
  }

  final pages = <Widget>[
    makeResumePage(),
    // makeIndicatorsPage(),//Dont make sense use this pages because is similar salesPage
    makeSalesPage(),
    makeProductsPage(),
    makeMorePage(),
    // makeTeamPage(),
  ];

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Get.find();

    mainErrorSubscription?.cancel();
    mainErrorSubscription =
        handleMainError(context, homePresenter.mainErrorStream);

    return StreamBuilder<int>(
      stream: homePresenter.currentPageIndexStream,
      builder: (context, currentIndex) {
        return Scaffold(
          body: Stack(
            children: [
              pages[currentIndex.data ?? 0],
              if (!loadedEnterprises)
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
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
                cupertinoIcon: Icon(CupertinoIcons.money_dollar),
                label: R.string.sales,
              ),
              BottomNavItem(
                materialIcon: Icon(Icons.shopping_cart_rounded),
                cupertinoIcon: Icon(CupertinoIcons.cart),
                label: R.string.products,
              ),
              BottomNavItem(
                materialIcon: Icon(Icons.grid_view_rounded),
                cupertinoIcon: Icon(CupertinoIcons.square_grid_2x2_fill),
                label: R.string.more,
              ),
              // BottomNavItem(
              //   materialIcon: Icon(Icons.person_pin_sharp),
              //   cupertinoIcon: Icon(CupertinoIcons.person_2),
              //   label: R.string.team,
              // ),
            ],
          ),
        );
      },
    );
  }
}

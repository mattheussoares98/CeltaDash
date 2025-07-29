import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        EnterprisesManagerPresenter enterprisesManagerPresenter = Get.find();

        mainErrorSubscription =
            handleMainError(context, homePresenter.mainErrorStream);

        await enterprisesManagerPresenter.loadLocalEnterprises();
        homePresenter.updateSelectedIndex(0);
        await homePresenter.getBsEnterprises();

        setState(() {
          loadedEnterprises = true;
        });

        resumePresenter.getSales(homePresenter, now: DateTime.now());
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    mainErrorSubscription?.cancel();
    final routeObserver = Get.find<RouteObserver<PageRoute>>();
    routeObserver.unsubscribe(this);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
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
    // ResumePresenter resumePresenter = Get.find();
    // HomePresenter homePresenter = Get.find();
    // SalesPresenter salesPresenter = Get.find();
    // ProductsPresenter productsPresenter = Get.find();
    // WidgetsBinding.instance.addPostFrameCallback(
    //   (_) => homePresenter.reloadSales(
    //     resumePresenter,
    //     salesPresenter,
    //     productsPresenter,
    //     now: DateTime.now(),
    //   ),
    // );
  }

  final pages = <Widget>[
    makeResumePage(),
    makeSalesPage(),
    makeProductsPage(),
    makePersonalizedPage(),
    makeMorePage(),
  ];

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Get.find();
    ResumePresenter resumePresenter = Get.find();

    final orientation = MediaQuery.of(context).orientation;
    if (orientation == Orientation.landscape) {
      // Remove the top that shows status bar
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: [SystemUiOverlay.bottom]);
    } else {
      // Add the top that shows status bar
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: SystemUiOverlay.values);
    }

    return Obx(() {
      final currentIndex = homePresenter.currentPageIndex;
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: EdgeInsets.only(
              top: orientation == Orientation.landscape ? 8 : 0),
          child: Stack(
            children: [
              pages[currentIndex],
              if (!loadedEnterprises)
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavBar(
          currentIndex: currentIndex,
          onTap: homePresenter.selectedEnterpriseIsEnabled
              ? (index) async {
                  homePresenter.updateSelectedIndex(index);
                  if (index == 0) {
                    await resumePresenter.getSales(homePresenter,
                        now: DateTime.now());
                  }
                }
              : (_) {
                  snackBarMessage(
                    context,
                    R.string.msgDisabledEnterprise,
                    Colors.red,
                  );
                },
          items: [
            const BottomNavItem(
              materialIcon: Icon(Icons.pie_chart),
              cupertinoIcon: Icon(CupertinoIcons.chart_pie),
              label: '',
            ),
            const BottomNavItem(
              materialIcon: Icon(Icons.monetization_on),
              cupertinoIcon: Icon(CupertinoIcons.money_dollar),
              label: '',
            ),
            const BottomNavItem(
              materialIcon: Icon(Icons.shopping_cart_rounded),
              cupertinoIcon: Icon(CupertinoIcons.cart),
              label: '',
            ),
            const BottomNavItem(
              materialIcon: Icon(Icons.assignment_ind),
              cupertinoIcon: Icon(CupertinoIcons.doc_person),
              label: '',
            ),
            const BottomNavItem(
              materialIcon: Icon(Icons.grid_view_rounded),
              cupertinoIcon: Icon(CupertinoIcons.square_grid_2x2_fill),
              label: '',
            ),
          ],
        ),
      );
    });
  }
}

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../../mixins/mixins.dart';
import '../pages.dart';

class WebEnterprisesPage extends StatefulWidget {
  final WebEnterprisesPresenter webEnterprisesPresenter;
  final AppAnalyticsPresenter analyticsPresenter;
  const WebEnterprisesPage({
    super.key,
    required this.webEnterprisesPresenter,
    required this.analyticsPresenter,
  });

  @override
  State<WebEnterprisesPage> createState() => _WebEnterprisesPageState();
}

class _WebEnterprisesPageState extends State<WebEnterprisesPage>
    with LoadingManager, UIErrorManager {
  StreamSubscription? loadingSubscription;
  StreamSubscription? mainErrorSubscription;
  final filterController = TextEditingController();
  int currentIndex = 0;
  final pageController = PageController();

  @override
  void initState() {
    super.initState();

    loadingSubscription =
        handleLoading(context, widget.webEnterprisesPresenter.isLoadingStream);
    mainErrorSubscription = handleMainError(
        context, widget.webEnterprisesPresenter.mainErrorStream);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        await widget.webEnterprisesPresenter.getEnterprises();
        await widget.analyticsPresenter.loadAnalytics();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
    filterController.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Get.put<AppAnalyticsPresenter>(widget.analyticsPresenter);
    Get.put<WebEnterprisesPresenter>(widget.webEnterprisesPresenter);

    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: (index) => setState(() => currentIndex = index),
        children: [
          WebEnterprisesListPage(filterController: filterController),
          const AppAnalyticsPage(),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
          pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        },
        items: [
          BottomNavItem(
            materialIcon: const Icon(Icons.home),
            cupertinoIcon: const Icon(CupertinoIcons.home),
            label: R.string.enterprises,
          ),
          BottomNavItem(
            materialIcon: const Icon(Icons.auto_graph_outlined),
            cupertinoIcon: const Icon(CupertinoIcons.graph_square),
            label: R.string.analytics,
          ),
        ],
      ),
    );
  }
}

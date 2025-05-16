import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../mixins/mixins.dart';
import '../pages.dart';

class WebEnterpriseDetailsPage extends StatefulWidget {
  const WebEnterpriseDetailsPage({super.key});

  @override
  State<WebEnterpriseDetailsPage> createState() =>
      _WebEnterpriseDetailsPageState();
}

class _WebEnterpriseDetailsPageState extends State<WebEnterpriseDetailsPage>
    with LoadingManager, UIErrorManager {
  StreamSubscription? loadingSubscription;
  StreamSubscription? mainErrorSubscription;

  @override
  void dispose() {
    super.dispose();
    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    WebEnterprisesPresenter webEnterprisesPresenter = Get.find();
    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();

    loadingSubscription =
        handleLoading(context, webEnterprisesPresenter.isLoadingStream);
    mainErrorSubscription =
        handleMainError(context, webEnterprisesPresenter.mainErrorStream);

    return Scaffold(
      appBar: AppBar(
        title: Text("ENTERPRISES DETAILS"),
        actions: [],
      ),
      body: Center(
        child: Text("Enterprises details"),
      ),
    );
  }
}

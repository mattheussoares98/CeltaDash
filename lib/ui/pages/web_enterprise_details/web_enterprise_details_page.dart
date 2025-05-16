import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../helpers/helpers.dart';
import '../../mixins/mixins.dart';
import '../pages.dart';
import 'components/components.dart';

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
  final urlController = TextEditingController();
  bool showChangeBaseUrl = false;

  @override
  void dispose() {
    super.dispose();
    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
    urlController.dispose();
  }

  @override
  void initState() {
    super.initState();

    final webEnterprisePresenter = Get.find<WebEnterprisesPresenter>();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted && webEnterprisePresenter.selectedEnterprise != null) {
        urlController.text =
            webEnterprisePresenter.selectedEnterprise?.baseUrl ?? "";
      }
    });
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

    final selectedEnterprise = webEnterprisesPresenter.selectedEnterprise;

    return Scaffold(
      appBar: AppBar(
        title: Text(selectedEnterprise?.enterpriseName ?? ""),
        actions: [],
      ),
      body: selectedEnterprise == null
          ? Center(child: Text(R.string.msgUnexpectedError))
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BaseUrl(
                      updateShowChangeBaseUrl: () {
                        setState(() {
                          showChangeBaseUrl = !showChangeBaseUrl;
                        });
                      },
                      showChangeBaseUrl: showChangeBaseUrl,
                    ),
                    if (showChangeBaseUrl)
                      BaseUrlField(
                        urlController: urlController,
                        onChange: () {
                          setState(() {
                            showChangeBaseUrl = false;
                          });
                        },
                      ),
                    SubEnterprises(),
                  ],
                ),
              ),
            ),
    );
  }
}

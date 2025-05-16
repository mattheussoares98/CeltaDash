import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../helpers/helpers.dart';
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
                    Text("${R.string.url}: ${selectedEnterprise.baseUrl}"),
                    if ((selectedEnterprise.firebaseSubEnterprises?.length ??
                            0) >
                        0)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          R.string.subEnterprises,
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                      ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount:
                          selectedEnterprise.firebaseSubEnterprises?.length ??
                              0,
                      itemBuilder: (context, index) {
                        final subEnterprise =
                            selectedEnterprise.firebaseSubEnterprises?[index];
                        return Container(
                          decoration: ContainerDecoration.decoration,
                          padding: EdgeInsets.all(8),
                          margin: EdgeInsets.symmetric(vertical: 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${subEnterprise?.personalizedCode} - ${subEnterprise?.name}",
                              ),
                              Text("${R.string.cnpj}: ${subEnterprise?.cnpj}"),
                            ],
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
    );
  }
}

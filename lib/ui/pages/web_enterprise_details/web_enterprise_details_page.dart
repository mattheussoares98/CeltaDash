import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
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
  final urlController = TextEditingController();

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
                    Text("${R.string.url}: ${selectedEnterprise.baseUrl}"),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: TextFormField(
                        decoration: FormFieldDecoration.decoration(
                          context: context,
                          labelText: R.string.url,
                          hintText: R.string.url,
                          suffixIcon: IconButton(
                            onPressed: () async {
                              await webEnterprisesPresenter.changeEnterpriseUrl(
                                newUrl: urlController.text,
                                docRef: FirebaseFirestore.instance
                                    .collection("enterprises")
                                    .doc(
                                      selectedEnterprise.firebaseId,
                                    ),
                              );
                              setState(() {});
                            },
                            icon: Icon(Icons.save),
                          ),
                        ),
                        controller: urlController,
                      ),
                    ),
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

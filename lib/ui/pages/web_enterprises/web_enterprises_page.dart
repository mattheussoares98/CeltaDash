import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../../mixins/mixins.dart';
import '../pages.dart';
import 'components/components.dart';

bool _showAnimation = true;

class WebEnterprisesPage extends StatefulWidget {
  final WebEnterprisesPresenter presenter;
  const WebEnterprisesPage({super.key, required this.presenter});

  @override
  State<WebEnterprisesPage> createState() => _WebEnterprisesPageState();
}

class _WebEnterprisesPageState extends State<WebEnterprisesPage>
    with LoadingManager, UIErrorManager {
  StreamSubscription? loadingSubscription;
  StreamSubscription? mainErrorSubscription;
  final filterController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        Get.put<WebEnterprisesPresenter>(widget.presenter);

        await widget.presenter.getEnterprises();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
    filterController.dispose();
  }

  void onTap(FirebaseEnterpriseViewModel enterprise) {
    widget.presenter.goToEnterpriseDetails(enterprise);
  }

  @override
  Widget build(BuildContext context) {
    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
    // FirebaseAuth.instance.signOut();

    loadingSubscription =
        handleLoading(context, widget.presenter.isLoadingStream);
    mainErrorSubscription =
        handleMainError(context, widget.presenter.mainErrorStream);

    return Scaffold(
      appBar: AppBar(
        title: Text(R.string.enterprises),
        actions: [
          AddEnterpriseButton(presenter: widget.presenter),
          IconButton(
            onPressed: () async {
              await widget.presenter.getEnterprises();
            },
            icon:
                Icon(Icons.refresh, color: Theme.of(context).primaryColorDark),
          ),
        ],
      ),
      body: StreamBuilder<List<FirebaseEnterpriseViewModel>?>(
          stream: widget.presenter.enterprisesStream,
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Center(
                child: Text(R.string.empty),
              );
            }
            final enterprises = snapshot.data!
                .where((e) =>
                    e.enterpriseName
                        ?.toLowerCase()
                        .contains(filterController.text.toLowerCase()) ??
                    false)
                .toList();

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: filterController,
                    onChanged: (_) {
                      setState(() {});
                    },
                    decoration: FormFieldDecoration.decoration(
                      context: context,
                      labelText: R.string.filter,
                      suffixIcon: Icon(
                        Platform.isIOS
                            ? CupertinoIcons.search
                            : Icons.search_rounded,
                      ),
                    ),
                  ),
                ),
                ScrollableTableItem(
                  columnsWidths: [150, 80, 60],
                  showAnimation: _showAnimation,
                  fixFirstColumn: true,
                  hideShowAnimation: () {
                    _showAnimation = false;
                  },
                  titles: [
                    PersonalizedTableCell(
                      value: R.string.enterprise,
                      isTitle: true,
                    ),
                    PersonalizedTableCell(
                      value: R.string.enabled,
                      isTitle: true,
                    ),
                    PersonalizedTableCell(
                      value: R.string.total,
                      isTitle: true,
                    ),
                  ],
                  rowValues: enterprises.map((enterprise) {
                    final totalQuantity =
                        enterprise.firebaseSubEnterprises?.length ?? 0;
                    final enabledQuantity = enterprise.firebaseSubEnterprises
                            ?.where((element) => element.enabled == "true")
                            .length ??
                        0;

                    return [
                      PersonalizedTableCell(
                        value: enterprise.enterpriseName,
                        onTap: () {
                          onTap(enterprise);
                        },
                      ),
                      PersonalizedTableCell(value: enabledQuantity),
                      PersonalizedTableCell(
                        value: totalQuantity,
                      ),
                    ];
                  }).toList(),
                ),
              ],
            );
          }),
    );
  }
}

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';
import 'components/components.dart';

bool _showAnimation = true;

class WebEnterprisesListPage extends StatefulWidget {
  final TextEditingController filterController;
  const WebEnterprisesListPage({
    super.key,
    required this.filterController,
  });

  @override
  State<WebEnterprisesListPage> createState() => _WebEnterprisesListPageState();
}

class _WebEnterprisesListPageState extends State<WebEnterprisesListPage> {
  void onTap(FirebaseEnterpriseViewModel enterprise) {
    final webEnterprisesPresenter = Get.find<WebEnterprisesPresenter>();
    webEnterprisesPresenter.goToEnterpriseDetails(enterprise);
  }

  @override
  Widget build(BuildContext context) {
    final webEnterprisesPresenter = Get.find<WebEnterprisesPresenter>();
    return Scaffold(
      appBar: AppBar(
        title: Text(R.string.enterprises),
        actions: [
          AddEnterpriseButton(presenter: webEnterprisesPresenter),
          IconButton(
            onPressed: webEnterprisesPresenter.getEnterprises,
            icon:
                Icon(Icons.refresh, color: Theme.of(context).primaryColorDark),
          ),
        ],
      ),
      body: Obx(() {
        final loadedEnterprises = webEnterprisesPresenter.enterprises;

        if (loadedEnterprises == null || loadedEnterprises.isEmpty) {
          return Center(
            child: Text(R.string.empty),
          );
        }
        final enterprises = loadedEnterprises
            .where((e) =>
                e.enterpriseName
                    ?.toLowerCase()
                    .contains(widget.filterController.text.toLowerCase()) ??
                false)
            .toList();

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: widget.filterController,
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
              pdfFileName: R.string.enterprises,
              columnsWidths: [150, 80, 60],
              showAnimation: _showAnimation,
              columnsIndexToSum: [1, 2],
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

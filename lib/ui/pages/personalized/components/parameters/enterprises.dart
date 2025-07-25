import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../helpers/helpers.dart';
import '../../../pages.dart';
import '../components.dart';

class Enterprises extends StatefulWidget {
  final ExpansibleController enterprisesController;
  final ExpansibleController periodsController;
  final void Function(bool collapseParameters) collapseAll;
  const Enterprises({
    super.key,
    required this.enterprisesController,
    required this.periodsController,
    required this.collapseAll,
  });

  @override
  State<Enterprises> createState() => _EnterprisesState();
}

class _EnterprisesState extends State<Enterprises> {
  @override
  Widget build(BuildContext context) {
    final personalizedPresenter = Get.find<PersonalizedPresenter>();
    final homePresenter = Get.find<HomePresenter>();

    final selectedId =
        personalizedPresenter.currentSelectedParams?.enterpriseIds?.first;
    final allEnterprises = homePresenter.enterprises;
    final selectedEnterprise = selectedId == null
        ? null
        : allEnterprises?.firstWhere((e) => e.id?.toInt() == selectedId);

    return DefaultExpansionTile(
      controller: widget.enterprisesController,
      title: RichText(
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          style: const TextStyle(
            color: Colors.black,
          ),
          children: [
            TextSpan(text: R.string.enterprise),
            if (selectedEnterprise != null)
              TextSpan(
                text:
                    " ${selectedEnterprise.personalizedCode} - ${selectedEnterprise.name}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
      children: allEnterprises
              ?.map(
                (e) => RadioListTile(
                  value: e.id?.toInt(),
                  dense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                  groupValue: selectedId,
                  toggleable: true,
                  title: Text(
                    "${e.personalizedCode} - ${e.name}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onChanged: (_) {
                    setState(() {
                      personalizedPresenter
                          .changeSelectedEnterprise(e.id!.toInt());
                    });
                    widget.collapseAll(false);
                    widget.periodsController.expand();
                  },
                ),
              )
              .toList() ??
          [],
    );
  }
}

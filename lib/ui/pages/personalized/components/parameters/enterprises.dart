import 'package:celta_dash/utils/utils.dart';
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
  void changeValue(PersonalizedPresenter presenter, EcEnterpriseViewModel e) {
    setState(() {
      presenter.changeSelectedEnterprise(e.id!.toInt()!);
    });
    widget.collapseAll(false);
    widget.periodsController.expand();
  }

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
          style: const TextStyle(color: Colors.black),
          children: [
            TextSpan(text: R.string.enterprise),
            if (selectedEnterprise != null)
              TextSpan(
                text:
                    " ${selectedEnterprise.personalizedCode} - ${selectedEnterprise.name}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
      children:
          allEnterprises
              ?.map(
                (e) => InkWell(
                  onTap: () {
                    changeValue(personalizedPresenter, e);
                  },
                  child: RadioGroup<int?>(
                    groupValue: e.id?.toInt(),
                    child: Row(
                      children: [
                        Radio(value: selectedId),
                        Expanded(
                          child: Text(
                            "${e.personalizedCode} - ${e.name}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    onChanged: (_) {
                      changeValue(personalizedPresenter, e);
                    },
                  ),
                ),
              )
              .toList() ??
          [],
    );
  }
}

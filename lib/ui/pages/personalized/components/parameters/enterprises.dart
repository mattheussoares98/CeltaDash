import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../helpers/helpers.dart';
import '../../../pages.dart';

class Enterprises extends StatefulWidget {
  const Enterprises({super.key});

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

    return Card(
      elevation: 10,
      margin: const EdgeInsets.all(4),
      child: ExpansionTile(
        initiallyExpanded: false,
        dense: true,
        childrenPadding: const EdgeInsets.all(4),
        // backgroundColor: backgroundColor,
        // collapsedBackgroundColor: backgroundColor,
        title: RichText(
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
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        children: allEnterprises
                ?.map(
                  (e) => Container(
                    decoration: ContainerDecoration.defaultDecoration,
                    child: RadioListTile(
                      value: e.id?.toInt(),
                      dense: true,
                      groupValue: selectedId,
                      title: Text(e.name ?? ''),
                      onChanged: (_) {
                        setState(() {
                          personalizedPresenter
                              .changeSelectedEnterprise(e.id!.toInt());
                        });
                      },
                    ),
                  ),
                )
                .toList() ??
            [],
      ),
    );
  }
}

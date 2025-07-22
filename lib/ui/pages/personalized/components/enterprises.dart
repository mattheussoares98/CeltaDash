import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../helpers/helpers.dart';
import '../../pages.dart';
import 'components.dart';

class Enterprises extends StatefulWidget {
  const Enterprises({super.key});

  @override
  State<Enterprises> createState() => _EnterprisesState();
}

class _EnterprisesState extends State<Enterprises> {
  @override
  Widget build(BuildContext context) {
    final homePresenter = Get.find<HomePresenter>();
    final personzalizedPresenter = Get.find<PersonalizedPresenter>();

    return DefaultExpansionTile(
      title: R.string.enterprises,
      children: homePresenter.enterprises!
          .map(
            (e) => CheckBoxItem(
              title: "${e.personalizedCode} - ${e.name}",
              value:
                  personzalizedPresenter.enterprisesIds.contains(e.id!.toInt()),
              onTap: () {
                setState(() {
                  personzalizedPresenter.changeEnterpriseIds(e.id!.toInt());
                });
              },
            ),
          )
          .toList(),
    );
  }
}

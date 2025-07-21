import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../helpers/helpers.dart';
import '../../pages.dart';
import 'components.dart';

class Enterprises extends StatelessWidget {
  const Enterprises({super.key});

  @override
  Widget build(BuildContext context) {
    final homePresenter = Get.find<HomePresenter>();
    final personzalized = Get.find<PersonalizedPresenter>();

    return DefaultExpansionTile(
      title: R.string.enterprises,
      children: homePresenter.enterprises!
          .map(
            (e) => CheckBoxItem(
              title: "${e.personalizedCode} - ${e.name}",
              onTap: () {
                personzalized.changeEnterpriseIds(e.id!.toInt());
              },
            ),
          )
          .toList(),
    );
  }
}

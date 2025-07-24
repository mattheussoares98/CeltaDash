import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../helpers/helpers.dart';
import '../../../pages.dart';
import '../components.dart';

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
      itemAboveChildren: (homePresenter.enterprises?.length ?? 0) > 2
          ? Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: TextButton.icon(
                icon: Icon(
                    Platform.isIOS ? CupertinoIcons.check_mark : Icons.check),
                onPressed: (homePresenter.enterprises?.length ?? 0) ==
                        (personzalizedPresenter
                                .currentSelectedParams?.enterpriseIds?.length ??
                            0)
                    ? null
                    : () {
                        setState(() {
                          personzalizedPresenter.selectAllEnterprises();
                        });
                      },
                label: Text(
                  R.string.selectAllEnterprises,
                ),
              ),
            )
          : null,
      children: homePresenter.enterprises!
          .map(
            (e) => CheckBoxItem(
              title: "${e.personalizedCode} - ${e.name}",
              value: personzalizedPresenter.currentSelectedParams?.enterpriseIds
                      ?.any((x) => e.id!.toInt() == x) ??
                  false,
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

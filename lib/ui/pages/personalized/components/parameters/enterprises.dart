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
    final personalizedPresenter = Get.find<PersonalizedPresenter>();
    final totalQuantity = homePresenter.enterprises?.length ?? 0;
    int selectedsQuantity = (personalizedPresenter
                    .currentSelectedParams?.enterpriseIds?.length ??
                0) ==
            0
        ? totalQuantity
        : personalizedPresenter.currentSelectedParams?.enterpriseIds?.length ??
            0;

    return DefaultExpansionTile(
      title: "${R.string.enterprises} ($selectedsQuantity/$totalQuantity)",
      itemAboveChildren: totalQuantity > 1
          ? Padding(
              padding: const EdgeInsets.only(bottom: 8, left: 24, right: 24),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodySmall,
                  children: [
                    TextSpan(
                      text: R
                          .string.msgReturnAllEnterprisesWhenNoOneIsNotSelected,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: Icon(
                          Platform.isIOS ? CupertinoIcons.info : Icons.info,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
      children: homePresenter.enterprises!
          .map(
            (e) => CheckBoxItem(
              title: "${e.personalizedCode} - ${e.name}",
              value: personalizedPresenter.currentSelectedParams?.enterpriseIds
                      ?.any((x) => e.id!.toInt() == x) ??
                  false,
              onTap: () {
                setState(() {
                  personalizedPresenter.changeSelectedEnterprise(e.id!.toInt());
                });
              },
            ),
          )
          .toList(),
    );
  }
}

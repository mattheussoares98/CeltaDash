import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';

class MorePage extends StatelessWidget {
  const MorePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Get.find();

    final buttons = <DefaultButton>[
      DefaultButton(
        onTap: homePresenter.goToOperatorsPage,
        title: R.string.operators,
      ),
      // DefaultButton(
      //   onTap: homePresenter.goToProfitabilityPage,
      //   title: R.string.profitability,
      // ),
      DefaultButton(
        onTap: homePresenter.goToCanceledSalesPage,
        title: R.string.canceledSales,
      ),
      DefaultButton(
        onTap: homePresenter.goToNotCanceledSalesPage,
        title: R.string.notCanceledSales,
      ),
      DefaultButton(
        onTap: homePresenter.goToSellersPage,
        title: R.string.sellers,
      ),
      DefaultButton(
        onTap: homePresenter.goToCompareDays,
        title: R.string.compareDays,
      ),
      DefaultButton(
        onTap: homePresenter.goToCompareMonths,
        title: R.string.compareMonths,
      ),
    ];
    buttons.sort((a, b) => a.title.compareTo(b.title));

    final isIOS = !kIsWeb && Platform.isIOS;

    return DefaultSafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(R.string.more),
          actions: [
            IconButton(
              onPressed: () {
                notificationDialog(
                  context: context,
                  titleMessage: R.string.msgReallyWantLogout,
                  content: null,
                  onPress: () async {
                    await homePresenter.doLogout();
                  },
                );
              },
              icon: Icon(
                isIOS ? CupertinoIcons.arrow_right_square : Icons.exit_to_app,
              ),
            )
          ],
        ),
        body: Obx(
          () {
            final enterprises = homePresenter.enterprises;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: enterprises == null || enterprises.isEmpty
                    ? [const EmptySales(isLoading: false)]
                    : buttons,
              ),
            );
          },
        ),
      ),
    );
  }
}

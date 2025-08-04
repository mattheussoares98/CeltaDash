import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../helpers/helpers.dart';
import '../../pages.dart';

class PagesSalesInformations extends StatelessWidget {
  const PagesSalesInformations({super.key});

  @override
  Widget build(BuildContext context) {
    final bsSalesPresenter = Get.find<BsSalesPresenter>();
    final resultSales = bsSalesPresenter.notCanceledSales;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(theme.platform == TargetPlatform.iOS
                          ? CupertinoIcons.arrow_left
                          : Icons.arrow_back_ios_new_outlined),
                    ),
                    Text(
                      "${R.string.page} ${resultSales?.actualPage}/${resultSales?.totalPages}",
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        theme.platform == TargetPlatform.iOS
                            ? CupertinoIcons.arrow_right
                            : Icons.arrow_forward_ios_outlined,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Text(
                  " ${R.string.sales} ${resultSales?.recordsOnThisPage}/${resultSales?.totalRecords}",
                  textAlign: TextAlign.end,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../helpers/helpers.dart';
import '../../pages.dart';

class PagesSalesInformations extends StatefulWidget {
  final bool isLoading;
  const PagesSalesInformations({super.key, required this.isLoading});

  @override
  State<PagesSalesInformations> createState() => _PagesSalesInformationsState();
}

class _PagesSalesInformationsState extends State<PagesSalesInformations> {
  @override
  Widget build(BuildContext context) {
    final bsSalesPresenter = Get.find<BsSalesPresenter>();
    final resultSales = bsSalesPresenter.notSales;
    final recordInThisPage = resultSales?.recordsOnThisPage ?? 1;
    final totalRecords = resultSales?.totalRecords ?? 0;
    final actualPage = resultSales?.actualPage ?? 1;
    final skippedRecords = (actualPage - 1) * 100 /* max sales number */;
    final firstSaleNumber = totalRecords - (totalRecords - skippedRecords) + 1;
    final lastSaleNumber = actualPage == resultSales?.totalPages
        ? totalRecords
        : recordInThisPage * actualPage;

    final theme = Theme.of(context);

    if (resultSales?.totalPages == 1) {
      return const SizedBox.shrink();
    }

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
                      onPressed:
                          bsSalesPresenter.notSales?.actualPage == 1 ||
                                  widget.isLoading
                              ? null
                              : () async {
                                  await bsSalesPresenter.changeSalesPage(false);
                                  setState(() {});
                                },
                      icon: Icon(
                        theme.platform == TargetPlatform.iOS
                            ? CupertinoIcons.arrow_left
                            : Icons.arrow_back_ios_new_outlined,
                      ),
                    ),
                    Text(
                      "${R.string.page} ${resultSales?.actualPage}/${resultSales?.totalPages}",
                    ),
                    IconButton(
                      onPressed:
                          bsSalesPresenter.notSales?.actualPage ==
                                      bsSalesPresenter
                                          .notSales?.totalPages ||
                                  widget.isLoading
                              ? null
                              : () async {
                                  await bsSalesPresenter.changeSalesPage(true);
                                  setState(() {});
                                },
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
                child: Column(
                  children: [
                    Text(R.string.sales),
                    Text(
                      "$firstSaleNumber-$lastSaleNumber/$totalRecords",
                      textAlign: TextAlign.end,
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

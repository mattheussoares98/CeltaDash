import 'package:celta_plus/ui/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/components.dart';
import '../pages.dart';

class OperatorsProductivityPage extends StatefulWidget {
  final OperatorsProductivityPresenter presenter;
  const OperatorsProductivityPage({super.key, required this.presenter});

  @override
  State<OperatorsProductivityPage> createState() =>
      _OperatorsProductivityPageState();
}

class _OperatorsProductivityPageState extends State<OperatorsProductivityPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      widget.presenter.getSales(Get.find<HomePresenter>());
    });
  }

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Get.find();

    return StreamBuilder(
        stream: widget.presenter.isLoadingStream,
        builder: (context, loadinSnapshot) {
          return Scaffold(
            appBar: DefaultAppBar(
              isLoading: loadinSnapshot.data == true,
              onChangeEnterprise: (_) {},
            ),
            body: Obx(() {
              final sales = widget.presenter.saleMovements?.filteredSales(
                enterprise: homePresenter.selectedEnterprise,
              );

              if (sales == null || sales.isEmpty) {
                return EmptySales(isLoading: loadinSnapshot.data == true);
              }

              return Column(
                children: [
                  SelectPeriodItems(items: [
                    SelectPeriodItems.createItem(
                      title: R.string.day,
                      onTap: () {},
                    ),
                    SelectPeriodItems.createItem(
                      title: R.string.month,
                      onTap: () {},
                    ),
                  ]),
                  TableItem(
                    titleMinHeight: 43,
                    indexToSort: 0,
                    columnIndexToCompareAndDetachBetterAndWorstValue: 1,
                    columnsIndexToSum: [1],
                    titles: [
                      PersonalizedTableCell(value: R.string.operators),
                      PersonalizedTableCell(value: R.string.operators),
                    ],
                    rowValues: [
                      [
                        PersonalizedTableCell(value: R.string.operators),
                        PersonalizedTableCell(value: R.string.operators),
                      ]
                    ],
                  ),
                ],
              );
            }),
          );
        });
  }
}

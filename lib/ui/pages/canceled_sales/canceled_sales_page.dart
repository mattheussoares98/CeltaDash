import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';

class CanceledSalesPage extends StatefulWidget {
  const CanceledSalesPage({super.key});

  @override
  State<CanceledSalesPage> createState() => _CanceledSalesPageState();
}

class _CanceledSalesPageState extends State<CanceledSalesPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        reloadSales();
      }
    });
  }

  void reloadSales() {
    final canceledSalesPresenter = Get.find<CanceledSalesPresenter>();
    final homePresenter = Get.find<HomePresenter>();
    canceledSalesPresenter.getSales(homePresenter);
  }

  @override
  Widget build(BuildContext context) {
    final canceledSalesPresenter = Get.find<CanceledSalesPresenter>();
    return StreamBuilder(
      stream: canceledSalesPresenter.isLoadingStream,
      builder: (context, loadingSnap) {
        return Scaffold(
          appBar: DefaultAppBar(
            isLoading: loadingSnap.data == true,
            onChangeEnterprise: (_) async {
              reloadSales();
            },
            onChangeDate: (_) async {
              reloadSales();
            },
            onTapRefresh: reloadSales,
          ),
          body: Obx(() {
            if (canceledSalesPresenter.dailySales == null) {
              return EmptySales(isLoading: loadingSnap.data == true);
            } else if (canceledSalesPresenter.dailySales!.isEmpty) {
              return Center(
                child: Image.asset(
                  "lib/ui/assets/images/no_canceled_sales.png",
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: MediaQuery.of(context).size.height * 0.6,
                ),
              );
            }

            return Column(
              children: [
                TableItem(
                  titleMinHeight: 43,
                  columnIndexToCompareAndDetachBetterAndWorstValue: 1,
                  columnsIndexToSum: [2],
                  indexToSort: 2,
                  tableColumnWidth: {
                    0: FixedColumnWidth(
                        MediaQuery.of(context).size.width * 0.2),
                  },
                  titles: [
                    PersonalizedTableCell(
                      value: R.string.couponNumberAbbreviated.toUpperCase(),
                    ),
                    PersonalizedTableCell(value: R.string.date),
                    PersonalizedTableCell(value: R.string.total),
                  ],
                  rowValues: [
                    ...canceledSalesPresenter.dailySales!.map((e) => [
                          PersonalizedTableCell(value: e.documentNumber),
                          PersonalizedTableCell(value: e.dateHourOfBilling),
                          PersonalizedTableCell(
                            value: e.totalLiquid,
                            isMoney: true,
                          ),
                        ]),
                  ],
                ),
              ],
            );
          }),
        );
      },
    );
  }
}

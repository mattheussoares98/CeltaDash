import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/models.dart';
import '../../../domain/helpers/helpers.dart';
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

  void reloadSales({bool? forceRefresh}) {
    final canceledSalesPresenter = Get.find<CanceledSalesPresenter>();
    final homePresenter = Get.find<HomePresenter>();
    canceledSalesPresenter.getSales(homePresenter, forceRefresh: forceRefresh);
  }

  @override
  Widget build(BuildContext context) {
    final canceledSalesPresenter = Get.find<CanceledSalesPresenter>();
    final homePresenter = Get.find<HomePresenter>();

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
            onTapRefresh: () {
              reloadSales(forceRefresh: true);
            },
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SelectPeriodItems(
                  isLoading: loadingSnap.data,
                  selectedPeriodType: canceledSalesPresenter.selectedPeriod,
                  onTapDaily: () {
                    canceledSalesPresenter.getSales(
                      homePresenter,
                      periodType: PeriodType.daily,
                    );
                  },
                  onTapMonthly: () {
                    canceledSalesPresenter.getSales(
                      homePresenter,
                      periodType: PeriodType.monthly,
                    );
                  },
                ),
              ),
              Expanded(
                child: Obx(() {
                  final dailySales = canceledSalesPresenter.dailySales
                      ?.map((e) => SaleMovementModel.fromViewModel(e))
                      .where((e) {
                        return e.dateHourOfBilling?.year ==
                                homePresenter.selectedDate.year &&
                            e.dateHourOfBilling?.month ==
                                homePresenter.selectedDate.month &&
                            e.dateHourOfBilling?.day ==
                                homePresenter.selectedDate.day;
                      })
                      .toList()
                      .map((e) => e.toViewModel())
                      .toList();

                  final monthlySales = canceledSalesPresenter.monthlySales
                      ?.map((e) => SaleMovementModel.fromViewModel(e))
                      .where((e) {
                        return e.dateHourOfBilling?.year ==
                                homePresenter.selectedDate.year &&
                            e.dateHourOfBilling?.month ==
                                homePresenter.selectedDate.month;
                      })
                      .toList()
                      .map((e) => e.toViewModel())
                      .toList();

                  final sales =
                      canceledSalesPresenter.selectedPeriod == PeriodType.daily
                          ? dailySales
                          : monthlySales;

                  if (sales == null) {
                    return EmptySales(isLoading: loadingSnap.data == true);
                  } else if (sales.isEmpty) {
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
                            value:
                                R.string.couponNumberAbbreviated.toUpperCase(),
                          ),
                          PersonalizedTableCell(value: R.string.date),
                          PersonalizedTableCell(value: R.string.total),
                        ],
                        rowValues: [
                          ...sales.map((e) => [
                                PersonalizedTableCell(value: e.documentNumber),
                                PersonalizedTableCell(
                                  value: e.dateHourOfBilling,
                                ),
                                PersonalizedTableCell(
                                  value: e.totalLiquid,
                                  isMoney: true,
                                  onTap: () {
                                    canceledSalesPresenter
                                        .updateSelectedSaleMovement(e);
                                  },
                                ),
                              ]),
                        ],
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}

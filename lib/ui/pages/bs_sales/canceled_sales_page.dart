import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../data/models/models.dart';
import '../../../domain/helpers/helpers.dart';
import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';

bool _showAnimation = true;

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
    final bsSalesPresenter = Get.find<BsSalesPresenter>();
    final homePresenter = Get.find<HomePresenter>();
    bsSalesPresenter.getCanceledSales(homePresenter,
        forceRefresh: forceRefresh);
  }

  @override
  Widget build(BuildContext context) {
    final bsSalesPresenter = Get.find<BsSalesPresenter>();
    final homePresenter = Get.find<HomePresenter>();
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return StreamBuilder(
      stream: bsSalesPresenter.isLoadingStream,
      builder: (context, loadingSnap) {
        return Scaffold(
          body: DefaultSafeArea(
            child: Column(
              children: [
                DefaultAppBar(
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
                Padding(
                  padding: EdgeInsets.all(isPortrait ? 8 : 0),
                  child: SelectPeriodItems(
                    isLoading: loadingSnap.data,
                    selectedPeriodType: bsSalesPresenter.selectedPeriod,
                    onTapDaily: () {
                      bsSalesPresenter.getCanceledSales(
                        homePresenter,
                        periodType: PeriodType.daily,
                      );
                    },
                    onTapMonthly: () {
                      bsSalesPresenter.getCanceledSales(
                        homePresenter,
                        periodType: PeriodType.monthly,
                      );
                    },
                  ),
                ),
                Expanded(
                  child: Obx(() {
                    final dailySales = bsSalesPresenter.dailyCanceledSales
                        ?.map((e) =>
                            SaleMovementCollectionItemModel.fromViewModel(e))
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

                    final monthlySales = bsSalesPresenter.monthlyCanceledSales
                        ?.map((e) =>
                            SaleMovementCollectionItemModel.fromViewModel(e))
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
                        bsSalesPresenter.selectedPeriod == PeriodType.daily
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
                        ScrollableTableItem(
                          titleMinHeight: isPortrait ? 43 : 30,
                          selectedPeriodType: bsSalesPresenter.selectedPeriod,
                          pdfFileName: R.string.canceledSales,
                          columnsIndexToSum: [3],
                          fixFirstColumn: true,
                          indexToSort: 2,
                          columnsWidths: [65, 35, 80, 90, 80, 150],
                          showAnimation: _showAnimation,
                          hideShowAnimation: () {
                            _showAnimation = false;
                          },
                          titles: [
                            PersonalizedTableCell(
                              value: R.string.couponNumberAbbreviated
                                  .toUpperCase(),
                              isTitle: true,
                            ),
                            PersonalizedTableCell(
                              value: R.string.pdv.toUpperCase(),
                              isTitle: true,
                            ),
                            PersonalizedTableCell(
                              value:
                                  "${R.string.date}${isPortrait ? '' : ' (${R.string.sale})'}",
                              subtile: isPortrait ? R.string.sale : null,
                              isTitle: true,
                            ),
                            PersonalizedTableCell(
                              value: R.string.total,
                              isTitle: true,
                            ),
                            PersonalizedTableCell(
                              value: R.string.cancelledBy,
                              isTitle: true,
                            ),
                            PersonalizedTableCell(
                              value: R.string.justification,
                              isTitle: true,
                            ),
                          ],
                          rowValues: sales.map((e) {
                            final dateTime = DateFormat("dd/MM/yyyy HH:mm:ss")
                                .parse(e.dateHourOfBilling!);
                            final formatted =
                                DateFormat("dd/MM/yyyy").format(dateTime);
                            return [
                              PersonalizedTableCell(value: e.documentNumber),
                              PersonalizedTableCell(value: e.cashierNumber),
                              PersonalizedTableCell(value: formatted),
                              PersonalizedTableCell(
                                value: e.totalLiquid?.toDouble(),
                                isMoney: true,
                                onTap: () {
                                  bsSalesPresenter
                                      .updateSelectedSaleMovement(e);
                                },
                              ),
                              PersonalizedTableCell(
                                value: e.userCancellation ?? "indefinido",
                              ),
                              PersonalizedTableCell(
                                value: e.motiveCancellation ?? "indefinido",
                              ),
                            ];
                          }).toList(),
                        ),
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

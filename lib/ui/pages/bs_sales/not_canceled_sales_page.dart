import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../data/models/models.dart';
import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';
import 'components/components.dart';

bool _showAnimation = true;

class NotCanceledSalesPage extends StatefulWidget {
  const NotCanceledSalesPage({super.key});

  @override
  State<NotCanceledSalesPage> createState() => _NotCanceledSalesPageState();
}

class _NotCanceledSalesPageState extends State<NotCanceledSalesPage> {
  bool alreadySearched = false;
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
                  showDatePicker: false,
                  paddingPattern: 8,
                  onChangeEnterprise: (_) async {},
                  onChangeDate: (_) async {},
                  onTapRefresh: () {},
                ),
                FilterNotCanceledSales(
                  isLoading: loadingSnap.data == true,
                  alreadySearched: alreadySearched,
                  onSearch: () {
                    setState(() {
                      alreadySearched = true;
                    });
                  },
                ),
                Expanded(
                  child: Obx(() {
                    final sales = bsSalesPresenter.notCanceledSales?.collection
                        .where((e) =>
                            e.enterpriseId ==
                            homePresenter.selectedEnterprise?.id)
                        .map((e) =>
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

                    if (!alreadySearched && loadingSnap.data == null) {
                      return const SizedBox.shrink();
                    } else if (sales == null || sales.isEmpty) {
                      return EmptySales(isLoading: loadingSnap.data == true);
                    }

                    return Column(
                      children: [
                        PagesSalesInformations(
                          isLoading: loadingSnap.data == true,
                        ),
                        ScrollableTableItem(
                          titleMinHeight: isPortrait ? 43 : 30,
                          selectedPeriodType: bsSalesPresenter.selectedPeriod,
                          pdfFileName: R.string.notCanceledSales,
                          columnsIndexToSum: [3],
                          fixFirstColumn: true,
                          indexToSort: 2,
                          columnsWidths: [65, 35, 80, 90],
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

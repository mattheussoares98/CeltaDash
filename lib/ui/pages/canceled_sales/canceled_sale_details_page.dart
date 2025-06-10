import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../helpers/helpers.dart';
import '../pages.dart';
import 'components/components.dart';

class CanceledSaleDetailsPage extends StatefulWidget {
  const CanceledSaleDetailsPage({super.key});

  @override
  State<CanceledSaleDetailsPage> createState() =>
      _CanceledSaleDetailsPageState();
}

class _CanceledSaleDetailsPageState extends State<CanceledSaleDetailsPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        final canceledSalesPresenter = Get.find<CanceledSalesPresenter>();
        await canceledSalesPresenter.getSelectedSaleDetails();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final canceledSalesPresenter = Get.find<CanceledSalesPresenter>();
    final homePresenter = Get.find<HomePresenter>();

    return StreamBuilder(
        stream: canceledSalesPresenter.selectedSaleStream,
        builder: (context, selectedSaleSnap) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                R.string.details,
              ),
            ),
            body: StreamBuilder(
                stream: canceledSalesPresenter.isLoadingStream,
                builder: (context, loadingSnap) {
                  if (loadingSnap.data == true) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final sale = selectedSaleSnap.data;

                  if (sale == null) {
                    return Center(
                      child: ElevatedButton(
                        onPressed: () {
                          canceledSalesPresenter.getSales(homePresenter);
                        },
                        child: Text(R.string.searchAgain),
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Enterprise(sale: sale),
                            TitleAndValue(
                              title: R.string.date,
                              value: sale.dateHourOfBilling,
                            ),
                            TitleAndValue(
                              title: R.string.cashierNumber,
                              value: sale.cashierNumber,
                            ),
                            TitleAndValue(
                              title: R.string.couponNumberAbbreviated,
                              value: sale.documentNumber,
                            ),

                            //customer
                            if (sale.customer != null) Customer(sale: sale),
                            TitleAndValue(
                              title: R.string.seller,
                              value: sale.seller?.Name,
                            ),
                            if (sale.seller != null)
                              TitleAndValue(
                                title: R.string.seller,
                                value:
                                    "${sale.seller?.PersonalizedCode} - ${sale.seller?.Name}",
                              ),
                            TitleAndValue(
                              title: R.string.type,
                              value: sale.fiscalNoteType?.Name,
                            ),
                            PaymentFinalizations(sale: sale),
                            Products(sale: sale),
                            Text(
                              "${R.string.total}: ${sale.totalLiquid?.toDouble().toString().toBrazilianNumber()}",
                            ),
                          ]),
                    ),
                  );
                }),
          );
        });
  }
}

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
                            Text("${R.string.date}: ${sale.dateHourOfBilling}"),
                            Text(
                              "${R.string.cashierNumber}: ${sale.cashierNumber}",
                            ),
                            Text(
                              "${R.string.couponNumberAbbreviated}: ${sale.documentNumber}",
                            ),
                            if (sale.seller != null)
                              Text(
                                "${R.string.seller}: ${sale.seller?.PersonalizedCode} - ${sale.seller?.Name}",
                              ),
                            //customer
                            if (sale.customer != null) Customer(sale: sale),
                            //fiscal note type
                            if (sale.fiscalNoteType != null)
                              Text(sale.fiscalNoteType?.Name ?? ""),
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

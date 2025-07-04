import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../helpers/helpers.dart';
import '../../mixins/mixins.dart';
import '../pages.dart';
import 'components/components.dart';

class CanceledSaleDetailsPage extends StatefulWidget {
  const CanceledSaleDetailsPage({super.key});

  @override
  State<CanceledSaleDetailsPage> createState() =>
      _CanceledSaleDetailsPageState();
}

class _CanceledSaleDetailsPageState extends State<CanceledSaleDetailsPage>
    with UIErrorManager {
  StreamSubscription? mainErrorSubscription;
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
  void dispose() {
    super.dispose();

    mainErrorSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final canceledSalesPresenter = Get.find<CanceledSalesPresenter>();

    mainErrorSubscription?.cancel();
    mainErrorSubscription = handleMainError(
      context,
      canceledSalesPresenter.mainErrorStream,
    );

    return StreamBuilder(
        stream: canceledSalesPresenter.selectedSaleStream,
        builder: (context, selectedSaleSnap) {
          return Scaffold(
            appBar: AppBar(
              toolbarHeight: 40,
              title: Text(R.string.details),
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
                          canceledSalesPresenter.getSelectedSaleDetails();
                        },
                        child: Text(R.string.searchAgain),
                      ),
                    );
                  }

                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Enterprise(sale: sale),
                              TitleAndValue(
                                title:
                                    "${R.string.date} ${R.string.sale.toLowerCase()}",
                                value: sale.dateHourOfBilling,
                              ),
                              TitleAndValue(
                                title:
                                    "${R.string.date} ${R.string.cancellation.toLowerCase()}",
                                value: sale.dateHourOfCancellation,
                              ),
                              if (sale.userCancellation?.name != null)
                                TitleAndValue(
                                  title: R.string.cancelledBy,
                                  value: sale.userCancellation?.name,
                                ),
                              TitleAndValue(
                                title: R.string.cashierNumber,
                                value: sale.cashierNumber,
                              ),
                              TitleAndValue(
                                title: R.string.coupon,
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
                            ],
                          ),
                        ),
                        //dont show the payment finalizations because when the sale is canceled in the PDV
                        //before the BS read the sale, dont save the payments in BS. But when cancel the
                        //sale after the BS already read the sale, it will save the payments in BS. This can
                        //cause confusion for the user
                        // PaymentFinalizations(sale: sale),
                        Expanded(child: Products(sale: sale)),
                      ]);
                }),
          );
        });
  }
}

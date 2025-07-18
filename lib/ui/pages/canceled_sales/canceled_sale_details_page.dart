import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/components.dart';
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<CanceledSalesPresenter>().getSelectedSaleDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    final presenter = Get.find<CanceledSalesPresenter>();

    return Scaffold(
      appBar: AppBar(
        title: Text(R.string.details),
      ),
      body: DefaultSafeArea(
        child: StreamBuilder(
            stream: presenter.isLoadingStream,
            builder: (context, loadingSnap) {
              return StreamBuilder(
                stream: presenter.selectedSaleStream,
                builder: (context, saleSnap) {
                  if (loadingSnap.data == true) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!saleSnap.hasData || saleSnap.data == null) {
                    return EmptySales(isLoading: loadingSnap.data == true);
                  }

                  final sale = saleSnap.data!;

                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CancellationSection(sale: sale),
                        SaleSection(sale: sale),
                        ProductsSection(sale: sale),
                      ],
                    ),
                  );
                },
              );
            }),
      ),
    );
  }
}

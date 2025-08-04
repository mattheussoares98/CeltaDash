import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';
import 'components/components.dart';

class BsSaleDetailsPage extends StatefulWidget {
  const BsSaleDetailsPage({super.key});

  @override
  State<BsSaleDetailsPage> createState() => _BsSaleDetailsPageState();
}

class _BsSaleDetailsPageState extends State<BsSaleDetailsPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<BsSalesPresenter>().getSelectedSaleDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    final presenter = Get.find<BsSalesPresenter>();

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

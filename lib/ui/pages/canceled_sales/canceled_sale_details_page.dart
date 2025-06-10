import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../pages.dart';

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
    return Scaffold(
      appBar: AppBar(title: Text("Canceled Sale Details")),
      body: Center(
        child: Text("Canceled Sale Details"),
      ),
    );
  }
}

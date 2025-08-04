import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../pages/pages.dart';

class Enterprise extends StatelessWidget {
  final SaleMovementCollectionItemViewModel sale;
  const Enterprise({
    super.key,
    required this.sale,
  });

  @override
  Widget build(BuildContext context) {
    final homePresenter = Get.find<HomePresenter>();

    final enterprises =
        homePresenter.enterprises?.where((e) => e.id == sale.enterpriseId);

    if (enterprises?.isEmpty == true) {
      return const SizedBox();
    }

    final enterprise = enterprises!.first;
    return Text(
      "${enterprise.personalizedCode} - ${enterprise.name}",
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }
}

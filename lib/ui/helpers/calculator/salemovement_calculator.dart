import 'package:celta_plus/ui/helpers/helpers.dart';

import '../../../data/models/models.dart';
import '../../pages/pages.dart';

extension SaleMovementsExtensions on List<SaleMovementViewModel> {
  double sumLiquidValue({
    DateTime? filterDate,
    BsEnterpriseViewModel? enterprise,
  }) {
    return _getSalesEntities(filterDate, enterprise)
        .fold(0.0, (p, e) => p + (e.LiquidValue ?? 0));
  }

  int quantitySales({
    DateTime? filterDate,
    BsEnterpriseViewModel? enterprise,
  }) {
    return _getSalesEntities(filterDate, enterprise).fold(
      0,
      (p, e) => p + (e.QuantitySales ?? 0),
    );
  }

  double ticketAverage({
    DateTime? filterDate,
    BsEnterpriseViewModel? enterprise,
  }) {
    return sumLiquidValue(filterDate: filterDate, enterprise: enterprise) /
        quantitySales(filterDate: filterDate, enterprise: enterprise);
  }

  List<SaleMovementModel> _getSalesEntities(
    DateTime? filterDate,
    BsEnterpriseViewModel? filterEnterprise,
  ) {
    var salesEntities =
        this.map((e) => SaleMovementModel.fromViewModel(e)).toList();

    if (filterEnterprise != null) {
      salesEntities = salesEntities
          .where((e) => e.EnterpriseId == filterEnterprise.Code?.toInt())
          .toList();
    }

    if (filterDate != null) {
      salesEntities =
          salesEntities.where((e) => e.Date?.day == filterDate.day).toList();
    }

    return salesEntities;
  }
}

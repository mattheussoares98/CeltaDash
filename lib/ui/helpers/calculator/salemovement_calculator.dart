import '../../../data/models/models.dart';
import '../../pages/pages.dart';

extension SaleMovementsExtensions on List<SaleMovementViewModel> {
  double totalByDay({
    DateTime? filterDate,
    BsEnterpriseViewModel? enterprise,
  }) {
    return _getSalesEntities(filterDate, enterprise)
        .fold(0.0, (p, e) => p + (e.LiquidValue ?? 0));
  }

  List<SaleMovementModel> _getSalesEntities(
    DateTime? filterDate,
    BsEnterpriseViewModel? filterEnterprise,
  ) {
    var salesEntities =
        this.map((e) => SaleMovementModel.fromViewModel(e)).toList();

    if (filterEnterprise != null) {
      salesEntities = salesEntities
          .where((e) =>
              e.Enterprise.toString()
                  .contains(filterEnterprise.PersonalizedCode.toString()) ==
              true)
          .toList();
    }

    if (filterDate != null) {
      salesEntities =
          salesEntities.where((e) => e.Date?.day == filterDate.day).toList();
    }

    return salesEntities;
  }
}

import '../../ui/helpers/helpers.dart';
import '../usecases/usecases.dart';

enum CategoryGroupingType {
  cashierOperator,
  paymentFinalization,
  paymentModality,
  product,
  productDepartment,
  productSection,
  seller,
}

extension CategoryGroupingTypeExtension on CategoryGroupingType {
  String get name {
    switch (this) {
      case CategoryGroupingType.cashierOperator:
        return R.string.operator;
      case CategoryGroupingType.paymentFinalization:
        return R.string.finalization;
      case CategoryGroupingType.paymentModality:
        return R.string.paymentsType;
      case CategoryGroupingType.product:
        return R.string.product;
      case CategoryGroupingType.productDepartment:
        return R.string.department;
      case CategoryGroupingType.productSection:
        return R.string.section;
      case CategoryGroupingType.seller:
        return R.string.seller;
    }
  }
}

extension SaleStatisticsCategoryGrouping on GetSaleStatisticsParams {
  bool isCategoryGroupingSelected(CategoryGroupingType type) {
    switch (type) {
      case CategoryGroupingType.product:
        return groupByProduct ?? false;
      case CategoryGroupingType.productSection:
        return groupByProductSection ?? false;
      case CategoryGroupingType.paymentFinalization:
        return groupByPaymentFinalization ?? false;
      case CategoryGroupingType.paymentModality:
        return groupByPaymentModality ?? false;
      case CategoryGroupingType.cashierOperator:
        return groupByCashierOperator ?? false;
      case CategoryGroupingType.seller:
        return groupBySeller ?? false;
      case CategoryGroupingType.productDepartment:
        return groupByProductDepartment ?? false;
    }
  }
}

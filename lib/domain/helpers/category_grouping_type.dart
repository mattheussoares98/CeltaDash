import '../../ui/helpers/helpers.dart';

enum CategoryGroupingType {
  enterprise,
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
      case CategoryGroupingType.enterprise:
        return R.string.enterprise;
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

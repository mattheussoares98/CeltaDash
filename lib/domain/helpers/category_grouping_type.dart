import '../../ui/helpers/helpers.dart';

enum CategoryGroupingType {
  product,
  productDepartment,
  productSection,
  paymentFinalization,
  paymentModality,
  cashierOperator,
  seller,
}

extension CategoryGroupingTypeExtension on CategoryGroupingType {
  String get name {
    switch (this) {
      case CategoryGroupingType.product:
        return R.string.product;
      case CategoryGroupingType.productDepartment:
        return R.string.department;
      case CategoryGroupingType.productSection:
        return R.string.section;
      case CategoryGroupingType.paymentFinalization:
        return R.string.finalization;
      case CategoryGroupingType.paymentModality:
        return R.string.paymentsType;
      case CategoryGroupingType.cashierOperator:
        return R.string.operator;
      case CategoryGroupingType.seller:
        return R.string.seller;
    }
  }
}

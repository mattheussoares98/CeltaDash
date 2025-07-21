import '../../ui/helpers/helpers.dart';

enum ExclusiveGroupingType {
  product,
  productDepartment,
  productSection,
  paymentFinalization,
  paymentModality,
  cashierOperator,
  seller,
}

extension ExclusiveGroupingTypeExtension on ExclusiveGroupingType {
  String get name {
    switch (this) {
      case ExclusiveGroupingType.product:
        return R.string.product;
      case ExclusiveGroupingType.productDepartment:
        return R.string.department;
      case ExclusiveGroupingType.productSection:
        return R.string.section;
      case ExclusiveGroupingType.paymentFinalization:
        return R.string.finalization;
      case ExclusiveGroupingType.paymentModality:
        return R.string.paymentsType;
      case ExclusiveGroupingType.cashierOperator:
        return R.string.operator;
      case ExclusiveGroupingType.seller:
        return R.string.seller;
    }
  }
}

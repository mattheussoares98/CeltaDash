import '../../../ui/helpers/helpers.dart';

enum ReportType {
  canceledSales,
  compareDays,
  departments,
  operators,
  payments,
  personalized,
  products,
  resume,
  sales,
  sellers,
}

extension ReportTypeExtension on ReportType {
  String get description {
    switch (this) {
      case ReportType.canceledSales:
        return R.string.canceledSales;
      case ReportType.compareDays:
        return R.string.compareDays;
      case ReportType.departments:
        return R.string.departments;
      case ReportType.operators:
        return R.string.operators;
      case ReportType.payments:
        return R.string.payments;
      case ReportType.personalized:
        return R.string.personalized;
      case ReportType.products:
        return R.string.products;
      case ReportType.resume:
        return R.string.resume;
      case ReportType.sales:
        return R.string.sales;
      case ReportType.sellers:
        return R.string.sellers;
    }
  }
}

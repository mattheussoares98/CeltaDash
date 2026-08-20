import '../../../ui/helpers/helpers.dart';

enum ReportType {
  sales,
  compareDays,
  compareMonths,
  departments,
  notSales,
  operators,
  payments,
  personalized,
  products,
  resume,
  sellers,
}

extension ReportTypeExtension on ReportType {
  String get description {
    switch (this) {
      case ReportType.sales:
        return R.string.sales;
      case ReportType.compareDays:
        return R.string.compareDays;
      case ReportType.compareMonths:
        return R.string.compareMonths;
      case ReportType.departments:
        return R.string.departments;
      case ReportType.notSales:
        return R.string.notSales;
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
      case ReportType.sellers:
        return R.string.sellers;
    }
  }
}

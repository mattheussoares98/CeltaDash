import '../usecases/usecases.dart';

enum CategoryGroupingType {
  cashierOperator('Operador'),
  paymentFinalization('Finalização'),
  paymentModality('Tipos de pagamento'),
  product('Produto'),
  productDepartment('Departamento'),
  productSection('Seção'),
  seller('Vendedor');

  final String label;
  const CategoryGroupingType(this.label);
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

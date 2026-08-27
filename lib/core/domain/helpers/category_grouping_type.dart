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

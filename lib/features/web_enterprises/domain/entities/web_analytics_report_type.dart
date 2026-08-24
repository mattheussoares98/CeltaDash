enum WebAnalyticsReportType {
  sales('Vendas'),
  compareDays('Comparativo diário'),
  compareMonths('Comparativo mensal'),
  departments('Departamentos'),
  notSales('Não vendas'),
  operators('Operadores'),
  payments('Pagamentos'),
  personalized('Personalizado'),
  products('Produtos'),
  resume('Resumo'),
  sellers('Vendedores');

  final String label;
  const WebAnalyticsReportType(this.label);
}

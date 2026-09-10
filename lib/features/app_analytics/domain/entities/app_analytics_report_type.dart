// lib/features/app_analytics/domain/entities/app_analytics_report_type.dart
enum AppAnalyticsReportType {
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
  sellers('Vendedores'),
  canceledSales('Vendas canceladas'),
  notCanceledSales('Vendas não canceladas'),
  financial('Financeiro'),
  financialGroupOfStores('Grupo de lojas financeiro'),
  buyMovements('Compra (movimentos)'),
  buyMovementProducts('Compra (produtos)'),
  dailyComparison('Comparativo diário'),
  groupOfStores('Grupo de lojas'),
  monthlyAnalysis('Análise mensal'),
  monthlyGoals('Metas mensais'),
  monthlyGoalComparison('Comparativo de metas'),
  goalHistoric('Histórico de metas'),
  groupSummary('Resumo do grupo'),
  saleDetails('Detalhes da venda');

  final String label;
  const AppAnalyticsReportType(this.label);
}

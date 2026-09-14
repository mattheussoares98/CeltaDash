// lib/features/app_analytics/domain/entities/app_analytics_report_type.dart
enum AppAnalyticsReportType {
  sales('Vendas'),
  compareDays('Vendas (Comparativo diário)'),
  compareMonths('Vendas (Comparativo mensal)'),
  departments('Vendas (Departamentos)'),
  notSales('Não vendas'),
  operators('Vendas (Operadores)'),
  payments('Vendas (Pagamentos)'),
  personalized('Vendas (Personalizado)'),
  products('Vendas (Produtos)'),
  resume('Vendas (Resumo)'),
  sellers('Vendas (Vendedores)'),
  canceledSales('Vendas (Canceladas)'),
  notCanceledSales('Vendas (Não canceladas)'),
  financial('Financeiro'),
  financialGroupOfStores('Financeiro (Grupo de lojas)'),
  buyMovements('Compra (movimentos)'),
  buyMovementProducts('Compra (produtos)'),
  buyMovementDepartments('Compra (departamentos)'),
  buyMovementGroupOfStores('Compra (grupo de lojas)'),
  dailyComparison('Vendas (Comparativo diário)'),
  groupOfStores('Vendas (Grupo de lojas)'),
  monthlyAnalysis('Vendas (Análise mensal)'),
  monthlyGoals('Vendas (Metas mensais)'),
  monthlyGoalComparison('Vendas (Comparativo de metas)'),
  goalHistoric('Vendas (Histórico de metas)'),
  groupSummary('Vendas (Resumo do grupo)'),
  saleDetails('Vendas (Detalhes da venda)');

  final String label;
  const AppAnalyticsReportType(this.label);
}

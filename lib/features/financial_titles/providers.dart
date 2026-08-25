// lib/features/financial_titles/providers.dart
import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/features/financial_titles/data/data.dart';
import 'package:celta_dash/features/financial_titles/domain/repository/repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@riverpod
IFinancialTitlesDatasource financialTitlesDatasource(Ref ref) {
  return FinancialTitlesDatasource(ref.watch(httpClientProvider));
}

@riverpod
IFinancialTitlesRepository financialTitlesRepository(Ref ref) {
  return FinancialTitlesRepositoryImpl(
    ref.watch(financialTitlesDatasourceProvider),
  );
}

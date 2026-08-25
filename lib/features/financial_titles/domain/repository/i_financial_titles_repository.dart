// lib/features/financial_titles/domain/repository/i_financial_titles_repository.dart
import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/features/financial_titles/domain/entities/entities.dart';

abstract class IFinancialTitlesRepository {
  Future<FinancialTitleDataResponseEntity> getData({
    required SearchFinancialTitleDataParams params,
    required EcParams ecParams,
  });
}

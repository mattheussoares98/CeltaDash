// lib/features/financial_titles/data/datasource/i_financial_titles_datasource.dart
import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/features/financial_titles/data/models/models.dart';
import 'package:celta_dash/features/financial_titles/domain/entities/entities.dart';

abstract class IFinancialTitlesDatasource {
  Future<FinancialTitleDataResponseModel> getData({
    required SearchFinancialTitleDataParams params,
    required EcParams ecParams,
  });
}

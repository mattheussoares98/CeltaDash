// lib/features/financial_titles/data/repository/financial_titles_repository_impl.dart
import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/features/financial_titles/data/datasource/datasource.dart';
import 'package:celta_dash/features/financial_titles/domain/entities/entities.dart';
import 'package:celta_dash/features/financial_titles/domain/repository/repository.dart';

class FinancialTitlesRepositoryImpl implements IFinancialTitlesRepository {
  final IFinancialTitlesDatasource _datasource;

  const FinancialTitlesRepositoryImpl(this._datasource);

  @override
  Future<FinancialTitleDataResponseEntity> getData({
    required SearchFinancialTitleDataParams params,
    required EcParams ecParams,
  }) async {
    final model = await _datasource.getData(
      params: params,
      ecParams: ecParams,
    );

    return model.toEntity(searchParameters: params);
  }
}

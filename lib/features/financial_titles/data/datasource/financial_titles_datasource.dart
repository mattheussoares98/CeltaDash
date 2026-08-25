// lib/features/financial_titles/data/datasource/financial_titles_datasource.dart
import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/data/http/http.dart';
import 'package:celta_dash/features/financial_titles/data/datasource/datasource.dart';
import 'package:celta_dash/features/financial_titles/data/models/models.dart';
import 'package:celta_dash/features/financial_titles/domain/entities/entities.dart';

class FinancialTitlesDatasource implements IFinancialTitlesDatasource {
  final HttpClient _httpClient;

  const FinancialTitlesDatasource(this._httpClient);

  @override
  Future<FinancialTitleDataResponseModel> getData({
    required SearchFinancialTitleDataParams params,
    required EcParams ecParams,
  }) async {
    final response = await _httpClient.request(
      url: "${ecParams.url}/api/FinancialTitles/GetData",
      method: "post",
      headers: ecParams.toHeaders(),
      body: params.toBody(),
    );

    return FinancialTitleDataResponseModel.fromJson(response as Map? ?? {});
  }
}

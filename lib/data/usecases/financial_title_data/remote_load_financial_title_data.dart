import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../main/builders/builders.dart';
import '../../http/http.dart';
import '../../models/models.dart';

class RemoteLoadFinancialTitleData implements LoadFinancialTitleData {
  final HttpClient httpAdapter;

  RemoteLoadFinancialTitleData(this.httpAdapter);

  @override
  Future<FinancialTitleDataResponseEntity> get(
    SearchFinancialTitleDataParams params, {
    String? url,
    String? userName,
    String? accessKey,
  }) async {
    final baseUrl = url ?? EnterpriseBuilder.entity?.baseUrl;
    final response = await httpAdapter.request(
      url: '$baseUrl/api/FinancialTitles/GetData',
      method: 'post',
      headers: {
        'user': userName ?? EnterpriseBuilder.entity?.bsUser?.name,
        'accessKey': accessKey ?? EnterpriseBuilder.entity?.bsUser?.AccessKey,
      },
      body: SearchFinancialTitleDataModel.fromEntity(params).toJson(),
    );

    return FinancialTitleDataResponseModel.fromJson(response).toEntity();
  }
}

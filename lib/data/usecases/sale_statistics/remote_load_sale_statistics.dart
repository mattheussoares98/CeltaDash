import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../main/builders/builders.dart';
import '../../http/http.dart';
import '../../models/models.dart';

class RemoteLoadSaleStatistics implements LoadSaleStatistics {
  final HttpClient httpAdapter;

  const RemoteLoadSaleStatistics(this.httpAdapter);

  @override
  Future<List<SaleStatisticsEntity>> get(GetSaleStatisticsParams params) async {
    final url = EnterpriseBuilder.entity?.baseUrl;
    final response = await httpAdapter.request(
      url: "$url/api/salemovements/getstatistics",
      method: "post",
      headers: {
        "user": EnterpriseBuilder.entity?.bsUser?.name,
        "accessKey": EnterpriseBuilder.entity?.bsUser?.AccessKey,
      },
      body: {
        "enterpriseIds": params.enterpriseIds,
        "topCount": params.topCount,
        "period": {
          "startDate": params.startDate.toIso8601String(),
          "endDate": params.endDate.toIso8601String(),
        },
        "groupByEnterprise": params.groupByEnterprise == true,
        "groupByYear": params.groupByYear == true,
        "groupByMonth": params.groupByMonth == true,
        "groupByDay": params.groupByDay == true,
        "groupByHour": params.groupByHour == true,
        "groupByProduct": params.groupByProduct == true,
        "groupByProductDepartment": params.groupByProductDepartment == true,
        "groupByProductSection": params.groupByProductSection == true,
        "groupByPaymentFinalization": params.groupByPaymentFinalization == true,
        "groupByPaymentModality": params.groupByPaymentModality == true,
        "groupByCashierOperator": params.groupByCashierOperator == true,
        "groupBySeller": params.groupBySeller == true,
      },
    );

    return (response['results'] as List)
        .map((e) => SaleStatisticsModel.fromJson(e).toEntity())
        .toList();
  }
}

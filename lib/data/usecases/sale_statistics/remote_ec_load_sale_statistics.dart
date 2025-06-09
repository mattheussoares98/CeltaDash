import 'package:celta_dash/domain/entities/sale_statistics_entity.dart';
import 'package:flutter/material.dart';

import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../main/builders/builders.dart';
import '../../http/http.dart';
import '../../models/models.dart';

class RemoteEcLoadSaleStatistics implements EcLoadSaleStatistics {
  final HttpClient httpAdapter;

  const RemoteEcLoadSaleStatistics(this.httpAdapter);

  @override
  Future<List<SaleStatisticsEntity>> get(GetEcSaleStatisticsParams params) async {
    final url = EnterpriseBuilder.entity?.baseUrl;

    try {
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
          "groupByPaymentFinalization":
              params.groupByPaymentFinalization == true,
          "groupByPaymentModality": params.groupByPaymentModality == true,
          "groupByCashierOperator": params.groupByCashierOperator == true,
          "groupBySeller": params.groupBySeller == true,
        },
      );

      return (response['results'] as List)
          .map((e) => SaleStatisticsModel.fromJson(e).toEntity())
          .toList();
    } catch (e) {
      debugPrint(e.toString());
      throw DomainError.unexpected;
    }
  }
}

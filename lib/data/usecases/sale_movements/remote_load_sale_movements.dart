import 'package:celta_plus/domain/entities/sale_movement_entity.dart';
import 'package:flutter/material.dart';

import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../main/builders/builders.dart';
import '../../http/http.dart';
import '../../models/models.dart';

class RemoteLoadSaleMovements implements LoadSaleMovements {
  final HttpClient httpAdapter;

  const RemoteLoadSaleMovements(this.httpAdapter);

  @override
  Future<List<SaleMovementEntity>> get({
    required DateTime startDate,
    required DateTime endDate,
    List<int>? enterpriseIds,
    bool? groupByEnterprise,
    bool? groupByYear,
    bool? groupByMonth,
    bool? groupByDay,
    bool? groupByHour,
    bool? groupByProduct,
    bool? groupByProductDepartment,
    bool? groupByProductSection,
    bool? groupByPaymentFinalization,
    bool? groupByPaymentModality,
  }) async {
    final url = EnterpriseBuilder.entity?.ccsUrl;

    try {
      final response = await httpAdapter.request(
        url: "$url/api/salemovements/getstatistics",
        method: "post",
        headers: {
          "user": EnterpriseBuilder.entity?.bsUser?.name,
          "accessKey": EnterpriseBuilder.entity?.bsUser?.AccessKey,
        },
        body: {
          "enterpriseIds": enterpriseIds,
          "period": {
            "startDate": startDate.toIso8601String(),
            "endDate": endDate.toIso8601String(),
          },
          "groupByEnterprise": groupByEnterprise,
          "groupByYear": groupByYear,
          "groupByMonth": groupByMonth,
          "groupByDay": groupByDay,
          "groupByHour": groupByHour,
          "groupByProduct": groupByProduct,
          "groupByProductDepartment": groupByProductDepartment,
          "groupByProductSection": groupByProductSection,
          "groupByPaymentFinalization": groupByPaymentFinalization,
          "groupByPaymentModality": groupByPaymentModality,
        },
      );

      return (response['results'] as List)
          .map((e) => SaleMovementModel.fromJson(e).toEntity())
          .toList();
    } catch (e) {
      debugPrint(e.toString());
      throw DomainError.unexpected;
    }
  }
}

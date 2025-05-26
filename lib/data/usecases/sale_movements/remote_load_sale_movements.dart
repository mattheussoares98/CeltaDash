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
    bool? groupByCashierOperator,
  }) async {
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
          "enterpriseIds": enterpriseIds,
          "period": {
            "startDate": startDate.toIso8601String(),
            "endDate": endDate.toIso8601String(),
          },
          "groupByEnterprise": groupByEnterprise == true,
          "groupByYear": groupByYear == true,
          "groupByMonth": groupByMonth == true,
          "groupByDay": groupByDay == true,
          "groupByHour": groupByHour == true,
          "groupByProduct": groupByProduct == true,
          "groupByProductDepartment": groupByProductDepartment == true,
          "groupByProductSection": groupByProductSection == true,
          "groupByPaymentFinalization": groupByPaymentFinalization == true,
          "groupByPaymentModality": groupByPaymentModality == true,
          "groupByCashierOperator": groupByCashierOperator == true,
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

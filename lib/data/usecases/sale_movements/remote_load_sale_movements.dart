import 'package:celta_plus/domain/entities/sale_movement_entity.dart';
import 'package:flutter/material.dart';

import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
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
  }) async {
    //TODO create EnterpriseBuilder;

    try {
      final response = await httpAdapter.request(
        url: "url/api/salemovements/getstatistics",
        method: "post",
        body: {
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
        },
      );

      return (response as List)
          .map((e) => SaleMovementModel.fromJson(e).toEntity())
          .toList();
    } catch (e) {
      debugPrint(e.toString());
      throw DomainError.unexpected;
    }
  }
}

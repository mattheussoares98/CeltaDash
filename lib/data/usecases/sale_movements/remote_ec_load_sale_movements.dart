import 'package:flutter/material.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../main/builders/builders.dart';
import '../../http/http.dart';
import '../../models/models.dart';

class RemoteEcLoadSaleMovements implements EcLoadSaleMovements {
  final HttpClient httpAdapter;

  const RemoteEcLoadSaleMovements(this.httpAdapter);

  @override
  Future<List<SaleMovementEntity>> get(
    GetEcSaleMovementParams params,
  ) async {
    final url = EnterpriseBuilder.entity?.baseUrl;

    try {
      final response = await httpAdapter.request(
        url: "$url/api/salemovements",
        method: "post",
        headers: {
          "user": EnterpriseBuilder.entity?.bsUser?.name,
          "accessKey": EnterpriseBuilder.entity?.bsUser?.AccessKey,
        },
        body: {
          "enterpriseIds": params.EnterpriseIds,
          "dateHourOfBilling": {
            "startDate": params.StartDate.toIso8601String(),
            "endDate": params.EndDate.toIso8601String(),
          },
          "DocumentNumbers": params.DocumentNumbers,
          "OnlyCancelled": params.OnlyCancelled,
          "MountFiscalNoteType": params.MountFiscalNoteType,
          "MountCustomer": params.MountCustomer,
          "MountSeller": params.MountSeller,
          "MountProducts": params.MountProducts,
          "MountPaymentFinalizations": params.MountPaymentFinalizations,
          "ActualPage": params.ActualPage ?? 1,
          "RecordsByPage": params.RecordsByPage ?? 100,
        },
      );

      return (response['collection'] as List)
          .map((e) => SaleMovementModel.fromJson(e).toEntity())
          .toList();
    } catch (e) {
      debugPrint(e.toString());
      throw DomainError.unexpected;
    }
  }
}

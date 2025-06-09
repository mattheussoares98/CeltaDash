import 'package:equatable/equatable.dart';

import '../../entities/entities.dart';

abstract class EcLoadSaleMovement {
  Future<List<SaleMovementEntity>> get(GetEcSaleMovementParams params);
}

class GetEcSaleMovementParams extends Equatable {
  final List<int> EnterpriseIds;
  final DateTime StartDate;
  final DateTime EndDate;
  final List<String>? DocumentNumbers;
  final bool? OnlyCancelled;
  final bool? MountFiscalNoteType;
  final bool? MountCustomer;
  final bool? MountSeller;
  final bool? MountProducts;
  final bool? MountPaymentFinalizations;
  final int? ActualPage;
  final int? RecordsByPage;

  const GetEcSaleMovementParams({
    required this.EnterpriseIds,
    required this.StartDate,
    required this.EndDate,
    this.DocumentNumbers,
    this.OnlyCancelled,
    this.MountFiscalNoteType,
    this.MountCustomer,
    this.MountSeller,
    this.MountProducts,
    this.MountPaymentFinalizations,
    this.ActualPage,
    this.RecordsByPage,
  });

  @override
  List<Object?> get props => [
        EnterpriseIds,
        StartDate,
        EndDate,
        DocumentNumbers,
        OnlyCancelled,
        MountFiscalNoteType,
        MountCustomer,
        MountSeller,
        MountProducts,
        MountPaymentFinalizations,
        ActualPage,
        RecordsByPage,
      ];
}

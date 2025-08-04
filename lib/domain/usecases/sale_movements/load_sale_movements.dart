import 'package:equatable/equatable.dart';

import '../../entities/entities.dart';
import '../../helpers/helpers.dart';

abstract class LoadSaleMovements {
  Future<List<SaleMovementCollectionItemEntity>> get(
      GetSaleMovementParams params);
}

class GetSaleMovementParams extends Equatable implements DateRangeParams {
  @override
  final List<int> enterpriseIds;
  @override
  final DateTime startDate;
  @override
  final DateTime endDate;
  final List<String>? documentNumbers;
  final bool? onlyCancelled;
  final bool? onlyNotCancelled;
  final bool? mountFiscalNoteType;
  final bool? mountCustomer;
  final bool? mountSeller;
  final bool? mountProducts;
  final bool? mountPaymentFinalizations;
  final int? actualPage;
  final int? recordsByPage;

  const GetSaleMovementParams({
    required this.enterpriseIds,
    required this.startDate,
    required this.endDate,
    this.documentNumbers,
    this.onlyCancelled,
    this.onlyNotCancelled,
    this.mountFiscalNoteType,
    this.mountCustomer,
    this.mountSeller,
    this.mountProducts,
    this.mountPaymentFinalizations,
    this.actualPage,
    this.recordsByPage,
  });

  @override
  List<Object?> get props => [
        enterpriseIds,
        startDate,
        endDate,
        documentNumbers,
        onlyCancelled,
        onlyNotCancelled,
        mountFiscalNoteType,
        mountCustomer,
        mountSeller,
        mountProducts,
        mountPaymentFinalizations,
        actualPage,
        recordsByPage,
      ];
}

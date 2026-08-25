import 'package:celta_dash/domain/helpers/helpers.dart';
import 'package:equatable/equatable.dart';

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

  Map toBody() => {
    'enterpriseIds': enterpriseIds,
    'dateHourOfBilling': {
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    },
    'DocumentNumbers': documentNumbers,
    'onlyCancelled': onlyCancelled ?? false,
    'OnlyNotCancelled': onlyNotCancelled ?? false,
    'MountFiscalNoteType': mountFiscalNoteType ?? false,
    'MountCustomer': mountCustomer ?? false,
    'MountSeller': mountSeller ?? false,
    'MountProducts': mountProducts ?? false,
    'MountPaymentFinalizations': mountPaymentFinalizations ?? false,
    'ActualPage': actualPage ?? 1,
    'RecordsByPage': recordsByPage ?? 100,
  };

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

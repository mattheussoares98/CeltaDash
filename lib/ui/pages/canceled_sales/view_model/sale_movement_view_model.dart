import 'package:equatable/equatable.dart';

import '../../pages.dart';

class SaleMovementViewModel extends Equatable {
  final String? Id;
  final String? enterpriseId;
  final String? fiscalNoteTypeId;
  final String? sellerId;
  final String? totalLiquid;
  final String? isCancelled;
  final String? dateHourOfBilling;
  final String? dateHourOfCancellation;
  final String? documentNumber;
  final String? cashierNumber;
  final SaleMovementFiscalNoteViewModel? fiscalNoteType;
  final SaleMovementCustomerViewModel? customer;
  final SaleMovementSellerViewModel? seller;
  final SaleMovementUserCancellationViewModel? userCancellation;
  final List<SaleMovementProductViewModel>? products;
  final List<SaleMovementFinalizationViewModel>? paymentFinalizations;

  const SaleMovementViewModel({
    required this.Id,
    required this.enterpriseId,
    required this.fiscalNoteTypeId,
    required this.sellerId,
    required this.documentNumber,
    required this.cashierNumber,
    required this.dateHourOfBilling,
    required this.dateHourOfCancellation,
    required this.totalLiquid,
    required this.isCancelled,
    required this.fiscalNoteType,
    required this.customer,
    required this.seller,
    required this.userCancellation,
    required this.products,
    required this.paymentFinalizations,
  });

  @override
  List<Object?> get props => [
        Id,
        enterpriseId,
        fiscalNoteTypeId,
        sellerId,
        documentNumber,
        cashierNumber,
        dateHourOfBilling,
        dateHourOfCancellation,
        totalLiquid,
        isCancelled,
        fiscalNoteType,
        customer,
        seller,
        userCancellation,
        products,
        paymentFinalizations,
      ];
}

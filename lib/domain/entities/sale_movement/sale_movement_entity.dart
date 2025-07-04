import 'package:equatable/equatable.dart';

import 'sale_movement.dart';

class SaleMovementEntity extends Equatable {
  final int? id;
  final int? enterpriseId;
  final int? fiscalNoteTypeId;
  final int? sellerId;
  final String? documentNumber;
  final String? cashierNumber;
  final DateTime? dateHourOfBilling;
  final DateTime? dateHourOfCancellation;
  final double? totalLiquid;
  final bool? isCancelled;
  final SaleMovementFiscalNoteEntity? fiscalNoteType;
  final SaleMovementCustomerEntity? customer;
  final SaleMovementSellerEntity? seller;
  final SaleMovementUserCancellationEntity? userCancellation;
  final List<SaleMovementProductEntity>? products;
  final List<SaleMovementFinalizationEntity>? paymentFinalizations;

  const SaleMovementEntity({
    required this.id,
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
        id,
        enterpriseId,
        fiscalNoteTypeId,
        fiscalNoteType,
        customer,
        sellerId,
        seller,
        documentNumber,
        dateHourOfBilling,
        dateHourOfCancellation,
        cashierNumber,
        totalLiquid,
        isCancelled,
        userCancellation,
        products,
        paymentFinalizations,
      ];
}

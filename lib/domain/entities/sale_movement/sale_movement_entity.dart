import 'package:equatable/equatable.dart';

import 'sale_movement.dart';

class SaleMovementEntity extends Equatable {
  final int? Id;
  final int? EnterpriseId;
  final int? FiscalNoteTypeId;
  final int? SellerId;
  final String? DocumentNumber;
  final String? CashierNumber;
  final DateTime? DateHourOfBilling;
  final double? TotalLiquid;
  final bool? IsCancelled;
  final SaleMovementFiscalNoteEntity? FiscalNoteType;
  final SaleMovementCustomerEntity? Customer;
  final SaleMovementSellerEntity? Seller;
  final List<SaleMovementProductEntity>? Products;
  final List<SaleMovementFinalizationEntity>? PaymentFinalizations;

  const SaleMovementEntity({
    required this.Id,
    required this.EnterpriseId,
    required this.FiscalNoteTypeId,
    required this.SellerId,
    required this.DocumentNumber,
    required this.CashierNumber,
    required this.DateHourOfBilling,
    required this.TotalLiquid,
    required this.IsCancelled,
    required this.FiscalNoteType,
    required this.Customer,
    required this.Seller,
    required this.Products,
    required this.PaymentFinalizations,
  });

  @override
  List<Object?> get props => [
        Id,
        EnterpriseId,
        FiscalNoteTypeId,
        FiscalNoteType,
        Customer,
        SellerId,
        Seller,
        DocumentNumber,
        DateHourOfBilling,
        CashierNumber,
        TotalLiquid,
        IsCancelled,
        Products,
        PaymentFinalizations,
      ];
}

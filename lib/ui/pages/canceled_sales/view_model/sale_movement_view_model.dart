import 'package:equatable/equatable.dart';

import 'sale_movement_fiscal_note_view_model.dart';
import 'sale_movement_customer_view_model.dart';
import 'sale_movement_seller_view_model.dart';
import 'sale_movement_product_view_model.dart';
import 'sale_movement_finalization_view_model.dart';

class EcSaleMovementViewModel extends Equatable {
  final String? Id;
  final String? EnterpriseId;
  final String? FiscalNoteTypeId;
  final String? SellerId;
  final String? TotalLiquid;
  final String? IsCancelled;
  final String? DateHourOfBilling;
  final String? DocumentNumber;
  final String? CashierNumber;
  final SaleMovementFiscalNoteViewModel? FiscalNoteType;
  final SaleMovementCustomerViewModel? Customer;
  final SaleMovementSellerViewModel? Seller;
  final List<SaleMovementProductViewModel>? Products;
  final List<SaleMovementFinalizationViewModel>? PaymentFinalizations;

  const EcSaleMovementViewModel({
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
        SellerId,
        DocumentNumber,
        CashierNumber,
        DateHourOfBilling,
        TotalLiquid,
        IsCancelled,
        FiscalNoteType,
        Customer,
        Seller,
        Products,
        PaymentFinalizations,
      ];
}

import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/entities.dart';
import '../../../ui/helpers/helpers.dart';
import '../../../ui/pages/pages.dart';
import 'sale_movement_fiscal_note_model.dart';
import 'sale_movement_customer_model.dart';
import 'sale_movement_seller_model.dart';
import 'sale_movement_product_model.dart';
import 'sale_movement_finalization_model.dart';

class SaleMovementModel extends Equatable {
  final int? Id;
  final int? EnterpriseId;
  final int? FiscalNoteTypeId;
  final int? SellerId;
  final String? DocumentNumber;
  final String? CashierNumber;
  final DateTime? DateHourOfBilling;
  final double? TotalLiquid;
  final bool? IsCancelled;
  final SaleMovementFiscalNoteModel? FiscalNoteType;
  final SaleMovementCustomerModel? Customer;
  final SaleMovementSellerModel? Seller;
  final List<SaleMovementProductModel>? Products;
  final List<SaleMovementFinalizationModel>? PaymentFinalizations;

  const SaleMovementModel({
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

  factory SaleMovementModel.fromJson(Map json) => SaleMovementModel(
        Id: json['Id'],
        EnterpriseId: json['EnterpriseId'],
        FiscalNoteTypeId: json['FiscalNoteTypeId'],
        SellerId: json['SellerId'],
        DocumentNumber: json['DocumentNumber'],
        CashierNumber: json['CashierNumber'],
        DateHourOfBilling: json['DateHourOfBilling'] != null
            ? DateTime.parse(json['DateHourOfBilling'])
            : null,
        TotalLiquid: (json['TotalLiquid'] as num?)?.toDouble(),
        IsCancelled: json['IsCancelled'] as bool?,
        FiscalNoteType: json['FiscalNoteType'] != null
            ? SaleMovementFiscalNoteModel.fromJson(
                json['FiscalNoteType'] as Map)
            : null,
        Customer: json['Customer'] != null
            ? SaleMovementCustomerModel.fromJson(json['Customer'] as Map)
            : null,
        Seller: json['Seller'] != null
            ? SaleMovementSellerModel.fromJson(json['Seller'] as Map)
            : null,
        Products: json['Products'] != null
            ? (json['Products'] as List)
                .map((e) => SaleMovementProductModel.fromJson(e as Map))
                .toList()
            : null,
        PaymentFinalizations: json['PaymentFinalizations'] != null
            ? (json['PaymentFinalizations'] as List)
                .map((e) => SaleMovementFinalizationModel.fromJson(e as Map))
                .toList()
            : null,
      );

  factory SaleMovementModel.fromEntity(SaleMovementEntity? entity) =>
      SaleMovementModel(
        Id: entity?.Id,
        EnterpriseId: entity?.EnterpriseId,
        FiscalNoteTypeId: entity?.FiscalNoteTypeId,
        SellerId: entity?.SellerId,
        DocumentNumber: entity?.DocumentNumber,
        CashierNumber: entity?.CashierNumber,
        DateHourOfBilling: entity?.DateHourOfBilling,
        TotalLiquid: entity?.TotalLiquid,
        IsCancelled: entity?.IsCancelled,
        FiscalNoteType: entity?.FiscalNoteType != null
            ? SaleMovementFiscalNoteModel.fromEntity(entity!.FiscalNoteType)
            : null,
        Customer: entity?.Customer != null
            ? SaleMovementCustomerModel.fromEntity(entity!.Customer)
            : null,
        Seller: entity?.Seller != null
            ? SaleMovementSellerModel.fromEntity(entity!.Seller)
            : null,
        Products: entity?.Products
            ?.map((e) => SaleMovementProductModel.fromEntity(e))
            .toList(),
        PaymentFinalizations: entity?.PaymentFinalizations
            ?.map((e) => SaleMovementFinalizationModel.fromEntity(e))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'Id': Id,
        'EnterpriseId': EnterpriseId,
        'FiscalNoteTypeId': FiscalNoteTypeId,
        'SellerId': SellerId,
        'DocumentNumber': DocumentNumber,
        'CashierNumber': CashierNumber,
        'DateHourOfBilling': DateHourOfBilling?.toIso8601String(),
        'TotalLiquid': TotalLiquid,
        'IsCancelled': IsCancelled,
        'FiscalNoteType': FiscalNoteType?.toJson(),
        'Customer': Customer?.toJson(),
        'Seller': Seller?.toJson(),
        'Products': Products?.map((e) => e.toJson()).toList(),
        'PaymentFinalizations':
            PaymentFinalizations?.map((e) => e.toJson()).toList(),
      };

  SaleMovementEntity toEntity() => SaleMovementEntity(
        Id: Id,
        EnterpriseId: EnterpriseId,
        FiscalNoteTypeId: FiscalNoteTypeId,
        SellerId: SellerId,
        DocumentNumber: DocumentNumber,
        CashierNumber: CashierNumber,
        DateHourOfBilling: DateHourOfBilling,
        TotalLiquid: TotalLiquid,
        IsCancelled: IsCancelled,
        FiscalNoteType: FiscalNoteType?.toEntity(),
        Customer: Customer?.toEntity(),
        Seller: Seller?.toEntity(),
        Products: Products?.map((e) => e.toEntity()).toList(),
        PaymentFinalizations:
            PaymentFinalizations?.map((e) => e.toEntity()).toList(),
      );

  EcSaleMovementViewModel toViewModel() {
    final df = DateFormat('yyyy-MM-dd HH:mm:ss');
    return EcSaleMovementViewModel(
      Id: Id?.toString(),
      EnterpriseId: EnterpriseId?.toString(),
      FiscalNoteTypeId: FiscalNoteTypeId?.toString(),
      SellerId: SellerId?.toString(),
      DocumentNumber: DocumentNumber,
      CashierNumber: CashierNumber,
      DateHourOfBilling:
          DateHourOfBilling != null ? df.format(DateHourOfBilling!) : null,
      TotalLiquid: TotalLiquid?.toString(),
      IsCancelled: IsCancelled?.toString(),
      FiscalNoteType: FiscalNoteType?.toViewModel(),
      Customer: Customer?.toViewModel(),
      Seller: Seller?.toViewModel(),
      Products: Products?.map((e) => e.toViewModel()).toList(),
      PaymentFinalizations:
          PaymentFinalizations?.map((e) => e.toViewModel()).toList(),
    );
  }

  factory SaleMovementModel.fromViewModel(EcSaleMovementViewModel viewModel) {
    final df = DateFormat('yyyy-MM-dd HH:mm:ss');
    return SaleMovementModel(
      Id: viewModel.Id?.toInt(),
      EnterpriseId: viewModel.EnterpriseId?.toInt(),
      FiscalNoteTypeId: viewModel.FiscalNoteTypeId?.toInt(),
      SellerId: viewModel.SellerId?.toInt(),
      DocumentNumber: viewModel.DocumentNumber,
      CashierNumber: viewModel.CashierNumber,
      DateHourOfBilling: viewModel.DateHourOfBilling != null
          ? df.parse(viewModel.DateHourOfBilling!)
          : null,
      TotalLiquid: viewModel.TotalLiquid?.toDouble(),
      IsCancelled: bool.tryParse(viewModel.IsCancelled ?? ""),
      FiscalNoteType: viewModel.FiscalNoteType != null
          ? SaleMovementFiscalNoteModel.fromViewModel(viewModel.FiscalNoteType!)
          : null,
      Customer: viewModel.Customer != null
          ? SaleMovementCustomerModel.fromViewModel(viewModel.Customer!)
          : null,
      Seller: viewModel.Seller != null
          ? SaleMovementSellerModel.fromViewModel(viewModel.Seller!)
          : null,
      Products: viewModel.Products?.map(
          (e) => SaleMovementProductModel.fromViewModel(e)).toList(),
      PaymentFinalizations: viewModel.PaymentFinalizations?.map(
          (e) => SaleMovementFinalizationModel.fromViewModel(e)).toList(),
    );
  }
}

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
  final int? enterpriseId;
  final int? fiscalNoteTypeId;
  final int? sellerId;
  final String? documentNumber;
  final String? cashierNumber;
  final DateTime? dateHourOfBilling;
  final double? totalLiquid;
  final bool? isCancelled;
  final SaleMovementFiscalNoteModel? fiscalNoteType;
  final SaleMovementCustomerModel? customer;
  final SaleMovementSellerModel? seller;
  final List<SaleMovementProductModel>? products;
  final List<SaleMovementFinalizationModel>? paymentFinalizations;

  const SaleMovementModel({
    required this.Id,
    required this.enterpriseId,
    required this.fiscalNoteTypeId,
    required this.sellerId,
    required this.documentNumber,
    required this.cashierNumber,
    required this.dateHourOfBilling,
    required this.totalLiquid,
    required this.isCancelled,
    required this.fiscalNoteType,
    required this.customer,
    required this.seller,
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
        totalLiquid,
        isCancelled,
        fiscalNoteType,
        customer,
        seller,
        products,
        paymentFinalizations,
      ];

  factory SaleMovementModel.fromJson(Map json) => SaleMovementModel(
        Id: json['id'],
        enterpriseId: json['enterpriseId'],
        fiscalNoteTypeId: json['fiscalNoteTypeId'],
        sellerId: json['sellerId'],
        documentNumber: json['documentNumber'],
        cashierNumber: json['cashierNumber'],
        dateHourOfBilling: json['dateHourOfBilling'] != null
            ? DateTime.parse(json['dateHourOfBilling'])
            : null,
        totalLiquid: (json['totalLiquid'] as num?)?.toDouble(),
        isCancelled: json['isCancelled'] as bool?,
        fiscalNoteType: json['fiscalNoteType'] != null
            ? SaleMovementFiscalNoteModel.fromJson(
                json['fiscalNoteType'] as Map)
            : null,
        customer: json['customer'] != null
            ? SaleMovementCustomerModel.fromJson(json['customer'] as Map)
            : null,
        seller: json['seller'] != null
            ? SaleMovementSellerModel.fromJson(json['seller'] as Map)
            : null,
        products: json['products'] != null
            ? (json['products'] as List)
                .map((e) => SaleMovementProductModel.fromJson(e as Map))
                .toList()
            : null,
        paymentFinalizations: json['paymentFinalizations'] != null
            ? (json['paymentFinalizations'] as List)
                .map((e) => SaleMovementFinalizationModel.fromJson(e as Map))
                .toList()
            : null,
      );

  factory SaleMovementModel.fromEntity(SaleMovementEntity? entity) =>
      SaleMovementModel(
        Id: entity?.id,
        enterpriseId: entity?.enterpriseId,
        fiscalNoteTypeId: entity?.fiscalNoteTypeId,
        sellerId: entity?.sellerId,
        documentNumber: entity?.documentNumber,
        cashierNumber: entity?.cashierNumber,
        dateHourOfBilling: entity?.dateHourOfBilling,
        totalLiquid: entity?.totalLiquid,
        isCancelled: entity?.isCancelled,
        fiscalNoteType: entity?.fiscalNoteType != null
            ? SaleMovementFiscalNoteModel.fromEntity(entity!.fiscalNoteType)
            : null,
        customer: entity?.customer != null
            ? SaleMovementCustomerModel.fromEntity(entity!.customer)
            : null,
        seller: entity?.seller != null
            ? SaleMovementSellerModel.fromEntity(entity!.seller)
            : null,
        products: entity?.products
            ?.map((e) => SaleMovementProductModel.fromEntity(e))
            .toList(),
        paymentFinalizations: entity?.paymentFinalizations
            ?.map((e) => SaleMovementFinalizationModel.fromEntity(e))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': Id,
        'enterpriseId': enterpriseId,
        'fiscalNoteTypeId': fiscalNoteTypeId,
        'sellerId': sellerId,
        'documentNumber': documentNumber,
        'cashierNumber': cashierNumber,
        'dateHourOfBilling': dateHourOfBilling?.toIso8601String(),
        'totalLiquid': totalLiquid,
        'isCancelled': isCancelled,
        'fiscalNoteType': fiscalNoteType?.toJson(),
        'customer': customer?.toJson(),
        'seller': seller?.toJson(),
        'products': products?.map((e) => e.toJson()).toList(),
        'paymentFinalizations':
            paymentFinalizations?.map((e) => e.toJson()).toList(),
      };

  SaleMovementEntity toEntity() => SaleMovementEntity(
        id: Id,
        enterpriseId: enterpriseId,
        fiscalNoteTypeId: fiscalNoteTypeId,
        sellerId: sellerId,
        documentNumber: documentNumber,
        cashierNumber: cashierNumber,
        dateHourOfBilling: dateHourOfBilling,
        totalLiquid: totalLiquid,
        isCancelled: isCancelled,
        fiscalNoteType: fiscalNoteType?.toEntity(),
        customer: customer?.toEntity(),
        seller: seller?.toEntity(),
        products: products?.map((e) => e.toEntity()).toList(),
        paymentFinalizations:
            paymentFinalizations?.map((e) => e.toEntity()).toList(),
      );

  EcSaleMovementViewModel toViewModel() {
    final df = DateFormat('yyyy-MM-dd HH:mm:ss');
    return EcSaleMovementViewModel(
      Id: Id?.toString(),
      enterpriseId: enterpriseId?.toString(),
      fiscalNoteTypeId: fiscalNoteTypeId?.toString(),
      sellerId: sellerId?.toString(),
      documentNumber: documentNumber,
      cashierNumber: cashierNumber,
      dateHourOfBilling:
          dateHourOfBilling != null ? df.format(dateHourOfBilling!) : null,
      totalLiquid: totalLiquid?.toString(),
      isCancelled: isCancelled?.toString(),
      fiscalNoteType: fiscalNoteType?.toViewModel(),
      customer: customer?.toViewModel(),
      seller: seller?.toViewModel(),
      products: products?.map((e) => e.toViewModel()).toList(),
      paymentFinalizations:
          paymentFinalizations?.map((e) => e.toViewModel()).toList(),
    );
  }

  factory SaleMovementModel.fromViewModel(EcSaleMovementViewModel viewModel) {
    final df = DateFormat('yyyy-MM-dd HH:mm:ss');
    return SaleMovementModel(
      Id: viewModel.Id?.toInt(),
      enterpriseId: viewModel.enterpriseId?.toInt(),
      fiscalNoteTypeId: viewModel.fiscalNoteTypeId?.toInt(),
      sellerId: viewModel.sellerId?.toInt(),
      documentNumber: viewModel.documentNumber,
      cashierNumber: viewModel.cashierNumber,
      dateHourOfBilling: viewModel.dateHourOfBilling != null
          ? df.parse(viewModel.dateHourOfBilling!)
          : null,
      totalLiquid: viewModel.totalLiquid?.toDouble(),
      isCancelled: bool.tryParse(viewModel.isCancelled ?? ""),
      fiscalNoteType: viewModel.fiscalNoteType != null
          ? SaleMovementFiscalNoteModel.fromViewModel(viewModel.fiscalNoteType!)
          : null,
      customer: viewModel.customer != null
          ? SaleMovementCustomerModel.fromViewModel(viewModel.customer!)
          : null,
      seller: viewModel.seller != null
          ? SaleMovementSellerModel.fromViewModel(viewModel.seller!)
          : null,
      products: viewModel.products
          ?.map((e) => SaleMovementProductModel.fromViewModel(e))
          .toList(),
      paymentFinalizations: viewModel.paymentFinalizations
          ?.map((e) => SaleMovementFinalizationModel.fromViewModel(e))
          .toList(),
    );
  }
}

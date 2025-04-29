import 'package:celta_plus/ui/helpers/helpers.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/entities.dart';
import '../../ui/pages/pages.dart';

class SaleMovementModel extends Equatable {
  final double? LiquidValue;
  final int? Year;
  final int? Month;
  final DateTime? Date;
  final int? Hour;
  final int? QuantitySales;
  final String? Product;
  final String? ProductDepartment;
  final String? ProductSection;
  final String? PaymentFinalization;
  final String? PaymentModality;
  final int? EnterpriseId;
  final String? EnterprisePersonalizedCode;
  final String? EnterpriseFantasyName;

  const SaleMovementModel({
    required this.LiquidValue,
    required this.Year,
    required this.Month,
    required this.Date,
    required this.Hour,
    required this.QuantitySales,
    required this.Product,
    required this.ProductDepartment,
    required this.ProductSection,
    required this.PaymentFinalization,
    required this.PaymentModality,
    required this.EnterpriseId,
    required this.EnterprisePersonalizedCode,
    required this.EnterpriseFantasyName,
  });

  @override
  List<Object?> get props => [
        LiquidValue,
        Year,
        Month,
        Date,
        Hour,
        Product,
        ProductDepartment,
        ProductSection,
        PaymentFinalization,
        PaymentModality,
        EnterpriseId,
        EnterprisePersonalizedCode,
        EnterpriseFantasyName,
        QuantitySales,
      ];

  factory SaleMovementModel.fromJson(Map json) => SaleMovementModel(
        LiquidValue: json['LiquidValue'],
        Year: json['Year'],
        Month: json['Month'],
        Date: json['Date'] == null ? null : DateTime.parse(json['Date']),
        Hour: json['Hour'],
        Product: json['Product'],
        ProductDepartment: json['ProductDepartment'],
        ProductSection: json['ProductSection'],
        PaymentFinalization: json['PaymentFinalization'],
        PaymentModality: json['PaymentModality'],
        EnterpriseId: json['EnterpriseId'],
        EnterprisePersonalizedCode: json['EnterprisePersonalizedCode'],
        EnterpriseFantasyName: json['EnterpriseFantasyName'],
        QuantitySales: json['QuantitySales'],
      );

  factory SaleMovementModel.fromEntity(SaleMovementEntity entity) =>
      SaleMovementModel(
        LiquidValue: entity.LiquidValue,
        Year: entity.Year,
        Month: entity.Month,
        Date: entity.Date,
        Hour: entity.Hour,
        Product: entity.Product,
        ProductDepartment: entity.ProductDepartment,
        ProductSection: entity.ProductSection,
        PaymentFinalization: entity.PaymentFinalization,
        PaymentModality: entity.PaymentModality,
        EnterpriseId: entity.EnterpriseId,
        EnterprisePersonalizedCode: entity.EnterprisePersonalizedCode,
        EnterpriseFantasyName: entity.EnterpriseFantasyName,
        QuantitySales: entity.QuantitySales,
      );

  Map<String, dynamic> toJson() => {
        'LiquidValue': LiquidValue,
        'Year': Year,
        'Month': Month,
        'Date': Date?.toIso8601String(),
        'Hour': Hour,
        'Product': Product,
        'ProductDepartment': ProductDepartment,
        'ProductSection': ProductSection,
        'PaymentFinalization': PaymentFinalization,
        'PaymentModality': PaymentModality,
        'EnterpriseId': EnterpriseId,
        'EnterprisePersonalizedCode': EnterprisePersonalizedCode,
        'EnterpriseFantasyName': EnterpriseFantasyName,
        'QuantitySales': QuantitySales,
      };

  SaleMovementEntity toEntity() => SaleMovementEntity(
        LiquidValue: LiquidValue,
        Year: Year,
        Month: Month,
        Date: Date,
        Hour: Hour,
        Product: Product,
        ProductDepartment: ProductDepartment,
        ProductSection: ProductSection,
        PaymentFinalization: PaymentFinalization,
        PaymentModality: PaymentModality,
        EnterpriseId: EnterpriseId,
        EnterprisePersonalizedCode: EnterprisePersonalizedCode,
        EnterpriseFantasyName: EnterpriseFantasyName,
        QuantitySales: QuantitySales,
      );

  factory SaleMovementModel.fromViewModel(SaleMovementViewModel viewModel) {
    final dateFormat = DateFormat('dd/MM/yyyy');

    DateTime? parsedDate;
    if (viewModel.Date != null) {
      try {
        parsedDate = dateFormat.parse(viewModel.Date!);
      } catch (_) {
        parsedDate = null;
      }
    }

    double? parsedLiquidValue = double.tryParse(viewModel.LiquidValue ?? '');
    int? parsedYear = int.tryParse(viewModel.Year ?? '');
    int? parsedMonth = int.tryParse(viewModel.Month ?? '');
    int? parsedHour;
    if (viewModel.Hour != null && viewModel.Hour!.contains(":")) {
      parsedHour = int.tryParse(viewModel.Hour!.split(":").first);
    }

    return SaleMovementModel(
      LiquidValue: parsedLiquidValue,
      Year: parsedYear,
      Month: parsedMonth,
      Date: parsedDate,
      Hour: parsedHour,
      Product: viewModel.Product,
      ProductDepartment: viewModel.ProductDepartment,
      ProductSection: viewModel.ProductSection,
      PaymentFinalization: viewModel.PaymentFinalization,
      PaymentModality: viewModel.PaymentModality,
      EnterpriseId: viewModel.EnterpriseId?.toInt(),
      EnterprisePersonalizedCode: viewModel.EnterprisePersonalizedCode,
      EnterpriseFantasyName: viewModel.EnterpriseFantasyName,
      QuantitySales: viewModel.QuantitySales?.toInt(),
    );
  }

  SaleMovementViewModel toViewModel() {
    final dateFormat = DateFormat('dd/MM/yyyy');

    return SaleMovementViewModel(
      Date: Date != null ? dateFormat.format(Date!) : null,
      LiquidValue: LiquidValue?.toString(),
      Year: Year?.toString(),
      Month: Month?.toString(),
      Hour: Hour != null ? '$Hour:00\n$Hour:59' : null,
      Product: Product,
      ProductDepartment: ProductDepartment,
      ProductSection: ProductSection,
      PaymentFinalization: PaymentFinalization,
      PaymentModality: PaymentModality,
      EnterpriseId: EnterpriseId?.toString(),
      EnterprisePersonalizedCode: EnterprisePersonalizedCode,
      EnterpriseFantasyName: EnterpriseFantasyName,
      QuantitySales: QuantitySales?.toString(),
    );
  }
}

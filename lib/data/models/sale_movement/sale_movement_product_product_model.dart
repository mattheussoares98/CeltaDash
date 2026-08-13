import 'package:celta_dash/domain/entities/entities.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:equatable/equatable.dart';

import '../../../ui/pages/pages.dart';

class SaleMovementProductProductModel extends Equatable {
  final int? Id;
  final String? Plu;
  final String? Name;
  final String? PackingAbbreviation;
  final double? PackingQuantity;

  const SaleMovementProductProductModel({
    required this.Id,
    required this.Plu,
    required this.Name,
    required this.PackingAbbreviation,
    required this.PackingQuantity,
  });

  @override
  List<Object?> get props => [
    Id,
    Plu,
    Name,
    PackingAbbreviation,
    PackingQuantity,
  ];

  factory SaleMovementProductProductModel.fromJson(Map json) =>
      SaleMovementProductProductModel(
        Id: json['id'],
        Plu: json['plu'],
        Name: json['name'],
        PackingAbbreviation: json['packingAbbreviation'],
        PackingQuantity: (json['packingQuantity'] as num?)?.toDouble(),
      );

  factory SaleMovementProductProductModel.fromEntity(
    SaleMovementProductProductEntity? entity,
  ) => SaleMovementProductProductModel(
    Id: entity?.Id,
    Plu: entity?.Plu,
    Name: entity?.Name,
    PackingAbbreviation: entity?.PackingAbbreviation,
    PackingQuantity: entity?.PackingQuantity,
  );

  Map<String, dynamic> toJson() => {
    'id': Id,
    'plu': Plu,
    'name': Name,
    'packingAbbreviation': PackingAbbreviation,
    'packingQuantity': PackingQuantity,
  };

  SaleMovementProductProductEntity toEntity() =>
      SaleMovementProductProductEntity(
        Id: Id,
        Plu: Plu,
        Name: Name,
        PackingAbbreviation: PackingAbbreviation,
        PackingQuantity: PackingQuantity,
      );

  SaleMovementProductProductViewModel toViewModel() =>
      SaleMovementProductProductViewModel(
        Id: Id?.toString(),
        Plu: Plu,
        Name: Name,
        PackingAbbreviation: PackingAbbreviation,
        PackingQuantity: PackingQuantity?.toString(),
      );

  factory SaleMovementProductProductModel.fromViewModel(
    SaleMovementProductProductViewModel viewModel,
  ) => SaleMovementProductProductModel(
    Id: viewModel.Id?.toInt(),
    Plu: viewModel.Plu,
    Name: viewModel.Name,
    PackingAbbreviation: viewModel.PackingAbbreviation,
    PackingQuantity: viewModel.PackingQuantity?.toDouble(),
  );
}

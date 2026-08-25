import 'package:celta_dash/features/sales_features/sales/data/models/models.dart';
import 'package:celta_dash/features/sales_features/sales/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class SaleMovementFinalizationModel extends Equatable {
  final int? Id;
  final double? Value;
  final int? QuantityOfPortions;
  final DateTime? DateOfExpiration;
  final SaleMovementFinalizationFinalizationModel? Finalization;

  const SaleMovementFinalizationModel({
    required this.Id,
    required this.Value,
    required this.QuantityOfPortions,
    required this.DateOfExpiration,
    required this.Finalization,
  });

  @override
  List<Object?> get props => [
    Id,
    Value,
    QuantityOfPortions,
    DateOfExpiration,
    Finalization,
  ];

  factory SaleMovementFinalizationModel.fromJson(Map json) =>
      SaleMovementFinalizationModel(
        Id: json['id'],
        Value: (json['value'] as num?)?.toDouble(),
        QuantityOfPortions: json['quantityOfPortions'],
        DateOfExpiration: json['dateOfExpiration'] != null
            ? DateTime.parse(json['dateOfExpiration'])
            : null,
        Finalization: json['finalization'] != null
            ? SaleMovementFinalizationFinalizationModel.fromJson(
                json['finalization'] as Map,
              )
            : null,
      );

  factory SaleMovementFinalizationModel.fromEntity(
    SaleMovementFinalizationEntity? entity,
  ) => SaleMovementFinalizationModel(
    Id: entity?.Id,
    Value: entity?.Value,
    QuantityOfPortions: entity?.QuantityOfPortions,
    DateOfExpiration: entity?.DateOfExpiration,
    Finalization: entity?.Finalization != null
        ? SaleMovementFinalizationFinalizationModel.fromEntity(
            entity!.Finalization,
          )
        : null,
  );

  Map<String, dynamic> toJson() => {
    'id': Id,
    'value': Value,
    'quantityOfPortions': QuantityOfPortions,
    'dateOfExpiration': DateOfExpiration?.toIso8601String(),
    'finalization': Finalization?.toJson(),
  };

  SaleMovementFinalizationEntity toEntity() => SaleMovementFinalizationEntity(
    Id: Id,
    Value: Value,
    QuantityOfPortions: QuantityOfPortions,
    DateOfExpiration: DateOfExpiration,
    Finalization: Finalization?.toEntity(),
  );

}

import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';
import 'sale_movement.dart';

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
        Id: json['Id'],
        Value: (json['Value'] as num?)?.toDouble(),
        QuantityOfPortions: json['QuantityOfPortions'],
        DateOfExpiration: json['DateOfExpiration'] != null
            ? DateTime.parse(json['DateOfExpiration'])
            : null,
        Finalization: json['Finalization'] != null
            ? SaleMovementFinalizationFinalizationModel.fromJson(
                json['Finalization'] as Map)
            : null,
      );

  factory SaleMovementFinalizationModel.fromEntity(
          SaleMovementFinalizationEntity? entity) =>
      SaleMovementFinalizationModel(
        Id: entity?.Id,
        Value: entity?.Value,
        QuantityOfPortions: entity?.QuantityOfPortions,
        DateOfExpiration: entity?.DateOfExpiration,
        Finalization: entity?.Finalization != null
            ? SaleMovementFinalizationFinalizationModel.fromEntity(
                entity!.Finalization)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'Id': Id,
        'Value': Value,
        'QuantityOfPortions': QuantityOfPortions,
        'DateOfExpiration': DateOfExpiration?.toIso8601String(),
        'Finalization': Finalization?.toJson(),
      };

  SaleMovementFinalizationEntity toEntity() => SaleMovementFinalizationEntity(
        Id: Id,
        Value: Value,
        QuantityOfPortions: QuantityOfPortions,
        DateOfExpiration: DateOfExpiration,
        Finalization: Finalization?.toEntity(),
      );
}

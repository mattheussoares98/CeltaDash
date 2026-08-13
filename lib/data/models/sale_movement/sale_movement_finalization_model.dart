import 'package:celta_dash/domain/entities/entities.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

import '../../../ui/pages/pages.dart';
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

  SaleMovementFinalizationViewModel toViewModel() {
    final df = DateFormat('yyyy-MM-dd HH:mm:ss');
    return SaleMovementFinalizationViewModel(
      Id: Id?.toString(),
      Value: Value?.toString(),
      QuantityOfPortions: QuantityOfPortions?.toString(),
      DateOfExpiration: DateOfExpiration != null
          ? df.format(DateOfExpiration!)
          : null,
      Finalization: Finalization?.toViewModel(),
    );
  }

  factory SaleMovementFinalizationModel.fromViewModel(
    SaleMovementFinalizationViewModel viewModel,
  ) {
    final df = DateFormat('yyyy-MM-dd HH:mm:ss');
    return SaleMovementFinalizationModel(
      Id: viewModel.Id?.toInt(),
      Value: viewModel.Value?.toDouble(),
      QuantityOfPortions: viewModel.QuantityOfPortions?.toInt(),
      DateOfExpiration: viewModel.DateOfExpiration != null
          ? df.parse(viewModel.DateOfExpiration!)
          : null,
      Finalization: viewModel.Finalization != null
          ? SaleMovementFinalizationFinalizationModel.fromViewModel(
              viewModel.Finalization!,
            )
          : null,
    );
  }
}

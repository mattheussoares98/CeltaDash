import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';
import '../../../ui/helpers/helpers.dart';
import '../../../ui/pages/pages.dart';

class SaleMovementFinalizationFinalizationModel extends Equatable {
  final int? Id;
  final String? Name;

  const SaleMovementFinalizationFinalizationModel({
    required this.Id,
    required this.Name,
  });

  @override
  List<Object?> get props => [Id, Name];

  factory SaleMovementFinalizationFinalizationModel.fromJson(Map json) =>
      SaleMovementFinalizationFinalizationModel(
        Id: json['id'],
        Name: json['name'],
      );

  factory SaleMovementFinalizationFinalizationModel.fromEntity(
          SaleMovementFinalizationFinalizationEntity? entity) =>
      SaleMovementFinalizationFinalizationModel(
        Id: entity?.Id,
        Name: entity?.Name,
      );

  Map<String, dynamic> toJson() => {
        'id': Id,
        'name': Name,
      };

  SaleMovementFinalizationFinalizationEntity toEntity() =>
      SaleMovementFinalizationFinalizationEntity(
        Id: Id,
        Name: Name,
      );

  SaleMovementFinalizationFinalizationViewModel toViewModel() =>
      SaleMovementFinalizationFinalizationViewModel(
        Id: Id?.toString(),
        Name: Name,
      );

  factory SaleMovementFinalizationFinalizationModel.fromViewModel(
          SaleMovementFinalizationFinalizationViewModel viewModel) =>
      SaleMovementFinalizationFinalizationModel(
        Id: viewModel.Id?.toInt(),
        Name: viewModel.Name,
      );
}

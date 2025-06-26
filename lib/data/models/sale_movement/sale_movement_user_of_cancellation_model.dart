import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';
import '../../../ui/helpers/helpers.dart';
import '../../../ui/pages/pages.dart';

class SaleMovementUserOfCancellationModel extends Equatable {
  final int? id;
  final String? name;

  const SaleMovementUserOfCancellationModel({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [
        id,
        name,
      ];

  factory SaleMovementUserOfCancellationModel.fromJson(Map json) =>
      SaleMovementUserOfCancellationModel(
        id: json['id'],
        name: json['name'],
      );

  factory SaleMovementUserOfCancellationModel.fromEntity(
          SaleMovementUserOfCancellationEntity? entity) =>
      SaleMovementUserOfCancellationModel(
        id: entity?.id,
        name: entity?.name,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };

  SaleMovementUserOfCancellationEntity toEntity() =>
      SaleMovementUserOfCancellationEntity(
        id: id,
        name: name,
      );

  SaleMovementUserOfCancellationViewModel toViewModel() =>
      SaleMovementUserOfCancellationViewModel(
        id: id?.toString(),
        name: name,
      );

  factory SaleMovementUserOfCancellationModel.fromViewModel(
          SaleMovementUserOfCancellationViewModel viewModel) =>
      SaleMovementUserOfCancellationModel(
        id: viewModel.id?.toInt(),
        name: viewModel.name,
      );
}

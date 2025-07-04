import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';
import '../../../ui/helpers/helpers.dart';
import '../../../ui/pages/pages.dart';

class SaleMovementUserCancellationModel extends Equatable {
  final int? id;
  final String? name;

  const SaleMovementUserCancellationModel({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [
        id,
        name,
      ];

  factory SaleMovementUserCancellationModel.fromJson(Map json) =>
      SaleMovementUserCancellationModel(
        id: json['id'],
        name: json['name'],
      );

  factory SaleMovementUserCancellationModel.fromEntity(
          SaleMovementUserCancellationEntity? entity) =>
      SaleMovementUserCancellationModel(
        id: entity?.id,
        name: entity?.name,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };

  SaleMovementUserCancellationEntity toEntity() =>
      SaleMovementUserCancellationEntity(
        id: id,
        name: name,
      );

  SaleMovementUserCancellationViewModel toViewModel() =>
      SaleMovementUserCancellationViewModel(
        id: id?.toString(),
        name: name,
      );

  factory SaleMovementUserCancellationModel.fromViewModel(
          SaleMovementUserCancellationViewModel viewModel) =>
      SaleMovementUserCancellationModel(
        id: viewModel.id?.toInt(),
        name: viewModel.name,
      );
}

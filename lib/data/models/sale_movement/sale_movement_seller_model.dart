import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';
import '../../../ui/helpers/helpers.dart';
import '../../../ui/pages/pages.dart';

class SaleMovementSellerModel extends Equatable {
  final int? Id;
  final String? PersonalizedCode;
  final String? Name;

  const SaleMovementSellerModel({
    required this.Id,
    required this.PersonalizedCode,
    required this.Name,
  });

  @override
  List<Object?> get props => [
        Id,
        PersonalizedCode,
        Name,
      ];

  factory SaleMovementSellerModel.fromJson(Map json) => SaleMovementSellerModel(
        Id: json['id'],
        PersonalizedCode: json['personalizedCode'],
        Name: json['name'],
      );

  factory SaleMovementSellerModel.fromEntity(
          SaleMovementSellerEntity? entity) =>
      SaleMovementSellerModel(
        Id: entity?.Id,
        PersonalizedCode: entity?.PersonalizedCode,
        Name: entity?.Name,
      );

  Map<String, dynamic> toJson() => {
        'id': Id,
        'personalizedCode': PersonalizedCode,
        'name': Name,
      };

  SaleMovementSellerEntity toEntity() => SaleMovementSellerEntity(
        Id: Id,
        PersonalizedCode: PersonalizedCode,
        Name: Name,
      );

  SaleMovementSellerViewModel toViewModel() => SaleMovementSellerViewModel(
        Id: Id?.toString(),
        PersonalizedCode: PersonalizedCode,
        Name: Name,
      );

  factory SaleMovementSellerModel.fromViewModel(
          SaleMovementSellerViewModel viewModel) =>
      SaleMovementSellerModel(
        Id: viewModel.Id?.toInt(),
        PersonalizedCode: viewModel.PersonalizedCode,
        Name: viewModel.Name,
      );
}

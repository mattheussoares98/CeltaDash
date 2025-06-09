import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';

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
        Id: json['Id'],
        PersonalizedCode: json['PersonalizedCode'],
        Name: json['Name'],
      );

  factory SaleMovementSellerModel.fromEntity(
          SaleMovementSellerEntity? entity) =>
      SaleMovementSellerModel(
        Id: entity?.Id,
        PersonalizedCode: entity?.PersonalizedCode,
        Name: entity?.Name,
      );

  Map<String, dynamic> toJson() => {
        'Id': Id,
        'PersonalizedCode': PersonalizedCode,
        'Name': Name,
      };

  SaleMovementSellerEntity toEntity() => SaleMovementSellerEntity(
        Id: Id,
        PersonalizedCode: PersonalizedCode,
        Name: Name,
      );
}

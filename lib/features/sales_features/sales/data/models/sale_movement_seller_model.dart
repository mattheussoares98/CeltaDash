import 'package:celta_dash/features/sales_features/sales/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

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
  List<Object?> get props => [Id, PersonalizedCode, Name];

  factory SaleMovementSellerModel.fromJson(Map json) => SaleMovementSellerModel(
    Id: json['id'],
    PersonalizedCode: json['personalizedCode'],
    Name: json['name'],
  );

  factory SaleMovementSellerModel.fromEntity(
    SaleMovementSellerEntity? entity,
  ) => SaleMovementSellerModel(
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

}

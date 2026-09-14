import 'package:celta_dash/features/buy_movement/domain/entities/entities.dart';

class BuyMovementDataProductModel extends BuyMovementDataProductEntity {
  const BuyMovementDataProductModel({
    required super.code,
    required super.priceLookupCode,
    required super.name,
    required super.packingAbbreviation,
    required super.packingQuantity,
    required super.quantity,
  });

  factory BuyMovementDataProductModel.fromJson(Map json) =>
      BuyMovementDataProductModel(
        code: ((json['Code'] ?? json['code']) as num?)?.toInt() ?? 0,
        priceLookupCode:
            (json['PriceLookupCode'] ?? json['priceLookupCode']) ?? '',
        name: (json['Name'] ?? json['name']) ?? '',
        packingAbbreviation:
            (json['PackingAbbreviation'] ?? json['packingAbbreviation']) ?? '',
        packingQuantity:
            (json['PackingQuantity'] ?? json['packingQuantity']) as num? ?? 0,
        quantity: (json['Quantity'] ?? json['quantity']) as num? ?? 0,
      );

  factory BuyMovementDataProductModel.fromEntity(
    BuyMovementDataProductEntity entity,
  ) => BuyMovementDataProductModel(
    code: entity.code,
    priceLookupCode: entity.priceLookupCode,
    name: entity.name,
    packingAbbreviation: entity.packingAbbreviation,
    packingQuantity: entity.packingQuantity,
    quantity: entity.quantity,
  );

  BuyMovementDataProductEntity toEntity() => BuyMovementDataProductEntity(
    code: code,
    priceLookupCode: priceLookupCode,
    name: name,
    packingAbbreviation: packingAbbreviation,
    packingQuantity: packingQuantity,
    quantity: quantity,
  );

  Map toJson() => {
    'Code': code,
    'PriceLookupCode': priceLookupCode,
    'Name': name,
    'PackingAbbreviation': packingAbbreviation,
    'PackingQuantity': packingQuantity,
    'Quantity': quantity,
  };

  @override
  List<Object?> get props => [
    code,
    priceLookupCode,
    name,
    packingAbbreviation,
    packingQuantity,
    quantity,
  ];
}

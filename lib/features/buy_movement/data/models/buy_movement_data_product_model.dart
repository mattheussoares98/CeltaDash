import 'package:celta_dash/features/buy_movement/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class BuyMovementDataProductModel extends Equatable {
  final int code;
  final int packingCode;
  final String name;
  final num quantity;

  const BuyMovementDataProductModel({
    required this.code,
    required this.packingCode,
    required this.name,
    required this.quantity,
  });

  factory BuyMovementDataProductModel.fromJson(Map json) =>
      BuyMovementDataProductModel(
        code: ((json['Code'] ?? json['code']) as num?)?.toInt() ?? 0,
        packingCode:
            ((json['PackingCode'] ?? json['packingCode']) as num?)?.toInt() ??
            0,
        name: (json['Name'] ?? json['name'])?.toString() ?? '',
        quantity: (json['Quantity'] ?? json['quantity']) as num? ?? 0,
      );

  factory BuyMovementDataProductModel.fromEntity(
    BuyMovementDataProductEntity entity,
  ) => BuyMovementDataProductModel(
    code: entity.code,
    packingCode: entity.packingCode,
    name: entity.name,
    quantity: entity.quantity,
  );

  BuyMovementDataProductEntity toEntity() => BuyMovementDataProductEntity(
    code: code,
    packingCode: packingCode,
    name: name,
    quantity: quantity,
  );

  Map toJson() => {
    'Code': code,
    'PackingCode': packingCode,
    'Name': name,
    'Quantity': quantity,
  };

  @override
  List<Object?> get props => [code, packingCode, name, quantity];
}

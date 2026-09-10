import 'package:celta_dash/features/buy_movement/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class BuyMovementDataSupplierModel extends Equatable {
  final int code;
  final String name;

  const BuyMovementDataSupplierModel({required this.code, required this.name});

  factory BuyMovementDataSupplierModel.fromJson(Map json) =>
      BuyMovementDataSupplierModel(
        code: ((json['Code'] ?? json['code']) as num?)?.toInt() ?? 0,
        name: (json['Name'] ?? json['name'])?.toString() ?? '',
      );

  factory BuyMovementDataSupplierModel.fromEntity(
    BuyMovementDataSupplierEntity entity,
  ) => BuyMovementDataSupplierModel(code: entity.code, name: entity.name);

  BuyMovementDataSupplierEntity toEntity() =>
      BuyMovementDataSupplierEntity(code: code, name: name);

  Map toJson() => {'Code': code, 'Name': name};

  @override
  List<Object?> get props => [code, name];
}

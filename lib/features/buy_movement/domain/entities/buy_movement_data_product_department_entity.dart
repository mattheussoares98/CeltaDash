import 'package:equatable/equatable.dart';

class BuyMovementDataProductDepartmentEntity extends Equatable {
  final int code;
  final String name;

  const BuyMovementDataProductDepartmentEntity({
    required this.code,
    required this.name,
  });

  @override
  List<Object?> get props => [code, name];
}

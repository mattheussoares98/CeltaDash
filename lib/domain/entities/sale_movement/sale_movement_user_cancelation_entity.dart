import 'package:equatable/equatable.dart';

class SaleMovementUserCancellationEntity extends Equatable {
  final int? id;
  final String? name;

  const SaleMovementUserCancellationEntity({
    required this.id,
    required this.name,
  });
  @override
  List<Object?> get props => [id, name];
}

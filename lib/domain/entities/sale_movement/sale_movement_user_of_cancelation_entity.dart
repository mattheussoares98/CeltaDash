import 'package:equatable/equatable.dart';

class SaleMovementUserOfCancellationEntity extends Equatable {
  final int? id;
  final String? name;

  const SaleMovementUserOfCancellationEntity({
    required this.id,
    required this.name,
  });
  @override
  List<Object?> get props => [id, name];
}

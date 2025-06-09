import 'package:equatable/equatable.dart';

class SaleMovementFinalizationFinalizationEntity extends Equatable {
  final int? Id;
  final String? Name;

  const SaleMovementFinalizationFinalizationEntity({
    required this.Id,
    required this.Name,
  });
  @override
  List<Object?> get props => [Id, Name];
}

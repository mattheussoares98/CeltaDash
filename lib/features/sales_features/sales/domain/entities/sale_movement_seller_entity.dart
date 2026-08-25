import 'package:equatable/equatable.dart';

class SaleMovementSellerEntity extends Equatable {
  final int? Id;
  final String? PersonalizedCode;
  final String? Name;

  const SaleMovementSellerEntity({
    required this.Id,
    required this.PersonalizedCode,
    required this.Name,
  });
  @override
  List<Object?> get props => [Id, PersonalizedCode, Name];
}

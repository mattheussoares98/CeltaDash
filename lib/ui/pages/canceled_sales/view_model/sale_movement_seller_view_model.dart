import 'package:equatable/equatable.dart';

class SaleMovementSellerViewModel extends Equatable {
  final String? Id;
  final String? PersonalizedCode;
  final String? Name;

  const SaleMovementSellerViewModel({
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
}

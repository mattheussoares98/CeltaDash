import 'package:equatable/equatable.dart';

class SaleMovementFinalizationFinalizationViewModel extends Equatable {
  final String? Id;
  final String? Name;

  const SaleMovementFinalizationFinalizationViewModel({
    required this.Id,
    required this.Name,
  });

  @override
  List<Object?> get props => [Id, Name];
}

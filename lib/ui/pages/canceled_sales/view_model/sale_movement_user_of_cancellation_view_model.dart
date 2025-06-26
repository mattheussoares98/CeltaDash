import 'package:equatable/equatable.dart';

class SaleMovementUserOfCancellationViewModel extends Equatable {
  final String? id;
  final String? name;

  const SaleMovementUserOfCancellationViewModel({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [
        id,
        name,
      ];
}

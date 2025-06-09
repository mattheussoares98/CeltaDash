import 'package:equatable/equatable.dart';

class SaleMovementFiscalNoteViewModel extends Equatable {
  final String? Id;
  final String? Name;

  const SaleMovementFiscalNoteViewModel({
    required this.Id,
    required this.Name,
  });

  @override
  List<Object?> get props => [Id, Name];
}

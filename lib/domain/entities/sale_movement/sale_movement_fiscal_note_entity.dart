import 'package:equatable/equatable.dart';

class SaleMovementFiscalNoteEntity extends Equatable {
  final int? Id;
  final String? Name;

  const SaleMovementFiscalNoteEntity({
    required this.Id,
    required this.Name,
  });

  @override
  List<Object?> get props => [Id, Name];
}

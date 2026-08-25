import 'package:celta_dash/features/sales_features/sales/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class SaleMovementFiscalNoteModel extends Equatable {
  final int? Id;
  final String? Name;

  const SaleMovementFiscalNoteModel({required this.Id, required this.Name});

  @override
  List<Object?> get props => [Id, Name];

  factory SaleMovementFiscalNoteModel.fromJson(Map json) =>
      SaleMovementFiscalNoteModel(Id: json['id'], Name: json['name']);

  factory SaleMovementFiscalNoteModel.fromEntity(
    SaleMovementFiscalNoteEntity? entity,
  ) => SaleMovementFiscalNoteModel(Id: entity?.Id, Name: entity?.Name);

  Map<String, dynamic> toJson() => {'id': Id, 'name': Name};

  SaleMovementFiscalNoteEntity toEntity() =>
      SaleMovementFiscalNoteEntity(Id: Id, Name: Name);

}

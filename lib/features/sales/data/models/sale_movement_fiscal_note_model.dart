import 'package:celta_dash/features/sales/domain/entities/entities.dart';
import 'package:celta_dash/ui/pages/pages.dart';
import 'package:celta_dash/utils/utils.dart';
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

  SaleMovementFiscalNoteViewModel toViewModel() =>
      SaleMovementFiscalNoteViewModel(Id: Id?.toString(), Name: Name);

  factory SaleMovementFiscalNoteModel.fromViewModel(
    SaleMovementFiscalNoteViewModel viewModel,
  ) => SaleMovementFiscalNoteModel(
    Id: viewModel.Id?.toInt(),
    Name: viewModel.Name,
  );
}

import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';
import '../../../ui/helpers/helpers.dart';
import '../../../ui/pages/pages.dart';

class SaleMovementFiscalNoteModel extends Equatable {
  final int? Id;
  final String? Name;

  const SaleMovementFiscalNoteModel({
    required this.Id,
    required this.Name,
  });

  @override
  List<Object?> get props => [Id, Name];

  factory SaleMovementFiscalNoteModel.fromJson(Map json) =>
      SaleMovementFiscalNoteModel(
        Id: json['Id'],
        Name: json['Name'],
      );

  factory SaleMovementFiscalNoteModel.fromEntity(
          SaleMovementFiscalNoteEntity? entity) =>
      SaleMovementFiscalNoteModel(
        Id: entity?.Id,
        Name: entity?.Name,
      );

  Map<String, dynamic> toJson() => {
        'Id': Id,
        'Name': Name,
      };

  SaleMovementFiscalNoteEntity toEntity() => SaleMovementFiscalNoteEntity(
        Id: Id,
        Name: Name,
      );

  SaleMovementFiscalNoteViewModel toViewModel() =>
      SaleMovementFiscalNoteViewModel(
        Id: Id?.toString(),
        Name: Name,
      );

  factory SaleMovementFiscalNoteModel.fromViewModel(
          SaleMovementFiscalNoteViewModel viewModel) =>
      SaleMovementFiscalNoteModel(
        Id: viewModel.Id?.toInt(),
        Name: viewModel.Name,
      );
}

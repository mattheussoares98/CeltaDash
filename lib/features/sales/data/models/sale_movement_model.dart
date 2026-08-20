import 'package:celta_dash/features/sales/data/models/models.dart';
import 'package:celta_dash/features/sales/domain/entities/entities.dart';
import 'package:celta_dash/ui/pages/pages.dart';
import 'package:equatable/equatable.dart';

class SaleMovementModel extends Equatable {
  final int totalRecords;
  final int recordsByPage;
  final int recordsOnThisPage;
  final int totalPages;
  final int actualPage;
  final List<SaleMovementCollectionItemModel> collection;

  const SaleMovementModel({
    required this.totalRecords,
    required this.recordsByPage,
    required this.recordsOnThisPage,
    required this.totalPages,
    required this.actualPage,
    required this.collection,
  });

  @override
  List<Object?> get props => [
    totalRecords,
    recordsByPage,
    recordsOnThisPage,
    totalPages,
    actualPage,
    collection,
  ];

  factory SaleMovementModel.fromJson(Map json) => SaleMovementModel(
    totalRecords: json["totalRecords"],
    recordsByPage: json["recordsByPage"],
    recordsOnThisPage: json["recordsOnThisPage"],
    totalPages: json["totalPages"],
    actualPage: json["actualPage"],
    collection: List<SaleMovementCollectionItemModel>.from(
      (json["collection"] as List).map(
        (x) => SaleMovementCollectionItemModel.fromJson(x),
      ),
    ),
  );

  Map<String, dynamic> toJson() => {
    "totalRecords": totalRecords,
    "recordsByPage": recordsByPage,
    "recordsOnThisPage": recordsOnThisPage,
    "totalPages": totalPages,
    "actualPage": actualPage,
    "collection": collection.map((e) => e.toJson()).toList(),
  };

  SaleMovementEntity toEntity() => SaleMovementEntity(
    totalRecords: totalRecords,
    recordsByPage: recordsByPage,
    recordsOnThisPage: recordsOnThisPage,
    totalPages: totalPages,
    actualPage: actualPage,
    collection: collection.map((e) => e.toEntity()).toList(),
  );

  factory SaleMovementModel.fromEntity(SaleMovementEntity entity) =>
      SaleMovementModel(
        totalRecords: entity.totalRecords,
        recordsByPage: entity.recordsByPage,
        recordsOnThisPage: entity.recordsOnThisPage,
        totalPages: entity.totalPages,
        actualPage: entity.actualPage,
        collection: entity.collection
            .map((e) => SaleMovementCollectionItemModel.fromEntity(e))
            .toList(),
      );

  SaleMovementViewModel toViewModel() => SaleMovementViewModel(
    totalRecords: totalRecords,
    recordsByPage: recordsByPage,
    recordsOnThisPage: recordsOnThisPage,
    totalPages: totalPages,
    actualPage: actualPage,
    collection: collection.map((e) => e.toViewModel()).toList(),
  );

  factory SaleMovementModel.fromViewModel(SaleMovementViewModel viewModel) =>
      SaleMovementModel(
        totalRecords: viewModel.totalRecords,
        recordsByPage: viewModel.recordsByPage,
        recordsOnThisPage: viewModel.recordsOnThisPage,
        totalPages: viewModel.totalPages,
        actualPage: viewModel.actualPage,
        collection: viewModel.collection
            .map((e) => SaleMovementCollectionItemModel.fromViewModel(e))
            .toList(),
      );
}

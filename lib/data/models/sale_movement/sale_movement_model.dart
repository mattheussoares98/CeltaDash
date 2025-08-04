import 'package:equatable/equatable.dart';

import '../models.dart';

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

  factory SaleMovementModel.fromJson(Map<String, dynamic> json) =>
      SaleMovementModel(
        totalRecords: json["totalRecords"],
        recordsByPage: json["recordsByPage"],
        recordsOnThisPage: json["recordsOnThisPage"],
        totalPages: json["totalPages"],
        actualPage: json["actualPage"],
        collection: List<SaleMovementCollectionItemModel>.from(
            (json["collection"] as List)
                .map((x) => SaleMovementCollectionItemModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "totalRecords": totalRecords,
        "recordsByPage": recordsByPage,
        "recordsOnThisPage": recordsOnThisPage,
        "totalPages": totalPages,
        "actualPage": actualPage,
        "collection": List<dynamic>.from(collection.map((x) => x.toJson)),
      };
}

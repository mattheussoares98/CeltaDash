import 'package:celta_dash/features/sales_features/sales/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class SaleMovementEntity extends Equatable {
  final int totalRecords;
  final int recordsByPage;
  final int recordsOnThisPage;
  final int totalPages;
  final int actualPage;
  final List<SaleMovementCollectionItemEntity> collection;

  const SaleMovementEntity({
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
}

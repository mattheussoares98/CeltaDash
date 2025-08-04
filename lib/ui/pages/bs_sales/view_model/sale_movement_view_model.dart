import 'package:equatable/equatable.dart';

import '../../pages.dart';

class SaleMovementViewModel extends Equatable {
  final int totalRecords;
  final int recordsByPage;
  final int recordsOnThisPage;
  final int totalPages;
  final int actualPage;
  final List<SaleMovementCollectionItemViewModel> collection;

  const SaleMovementViewModel({
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

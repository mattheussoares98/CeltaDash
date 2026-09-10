import 'package:celta_dash/features/buy_movement/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class SearchBuyMovementDataParamsEntity extends Equatable {
  final List<int> enterpriseCodes;
  final DateTime startDate;
  final DateTime endDate;
  final BuyMovementPeriodGrouping? periodGrouping;
  final bool groupByProduct;
  final bool groupBySupplier;
  final String? productName;
  final int? topCount;

  const SearchBuyMovementDataParamsEntity({
    required this.enterpriseCodes,
    required this.startDate,
    required this.endDate,
    this.periodGrouping,
    this.groupByProduct = false,
    this.groupBySupplier = false,
    this.productName,
    this.topCount,
  }) : assert(
         periodGrouping != null || groupByProduct || groupBySupplier,
         'Select at least one period, product, or supplier grouping.',
       ),
       assert(
         groupByProduct || (productName == null && topCount == null),
         'Product filters require product grouping.',
       ),
       assert(
         topCount == null || (topCount > 0 && topCount <= 500),
         'Top count must be between 1 and 500.',
       );

  @override
  List<Object?> get props => [
    enterpriseCodes,
    startDate,
    endDate,
    periodGrouping,
    groupByProduct,
    groupBySupplier,
    productName,
    topCount,
  ];
}

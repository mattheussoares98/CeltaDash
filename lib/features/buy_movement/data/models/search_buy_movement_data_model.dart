import 'package:celta_dash/features/buy_movement/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class SearchBuyMovementDataModel extends Equatable {
  final List<int> enterpriseCodes;
  final DateTime startDate;
  final DateTime endDate;
  final BuyMovementPeriodGrouping? periodGrouping;
  final bool groupByProduct;
  final bool groupBySupplier;
  final String? productName;
  final int? topCount;

  const SearchBuyMovementDataModel({
    required this.enterpriseCodes,
    required this.startDate,
    required this.endDate,
    this.periodGrouping,
    required this.groupByProduct,
    required this.groupBySupplier,
    this.productName,
    this.topCount,
  });

  factory SearchBuyMovementDataModel.fromJson(Map json) {
    final period = (json['Period'] ?? json['period']) as Map? ?? const {};

    return SearchBuyMovementDataModel(
      enterpriseCodes:
          ((json['EnterpriseCodes'] ?? json['enterpriseCodes']) as List?)
              ?.map((code) => (code as num).toInt())
              .toList() ??
          const [],
      startDate: _requiredDate(period['StartDate'] ?? period['startDate']),
      endDate: _requiredDate(period['EndDate'] ?? period['endDate']),
      periodGrouping: BuyMovementPeriodGrouping.fromValue(
        json['PeriodGrouping'] ?? json['periodGrouping'],
      ),
      groupByProduct:
          (json['GroupByProduct'] ?? json['groupByProduct']) == true,
      groupBySupplier:
          (json['GroupBySupplier'] ?? json['groupBySupplier']) == true,
      productName: json['ProductName'] ?? json['productName'],
      topCount: ((json['TopCount'] ?? json['topCount']) as num?)?.toInt(),
    );
  }

  factory SearchBuyMovementDataModel.fromEntity(
    SearchBuyMovementDataParamsEntity entity,
  ) => SearchBuyMovementDataModel(
    enterpriseCodes: entity.enterpriseCodes,
    startDate: entity.startDate,
    endDate: entity.endDate,
    periodGrouping: entity.periodGrouping,
    groupByProduct: entity.groupByProduct,
    groupBySupplier: entity.groupBySupplier,
    productName: entity.productName,
    topCount: entity.topCount,
  );

  SearchBuyMovementDataParamsEntity toEntity() =>
      SearchBuyMovementDataParamsEntity(
        enterpriseCodes: enterpriseCodes,
        startDate: startDate,
        endDate: endDate,
        periodGrouping: periodGrouping,
        groupByProduct: groupByProduct,
        groupBySupplier: groupBySupplier,
        productName: productName,
        topCount: topCount,
      );

  Map toJson() => {
    'EnterpriseCodes': enterpriseCodes,
    'Period': {
      'StartDate': startDate.toIso8601String(),
      'EndDate': endDate.toIso8601String(),
    },
    if (periodGrouping != null) 'PeriodGrouping': periodGrouping!.value,
    'GroupByProduct': groupByProduct,
    'GroupBySupplier': groupBySupplier,
    if (productName != null) 'ProductName': productName,
    if (topCount != null) 'TopCount': topCount,
  };

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

  static DateTime _requiredDate(dynamic value) {
    final date = DateTime.tryParse(value?.toString() ?? '');
    if (date == null) throw const FormatException('Invalid period date.');
    return date;
  }
}

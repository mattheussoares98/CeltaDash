import 'package:celta_dash/features/buy_movement/domain/entities/entities.dart';

class BuyMovementEntityFactory {
  BuyMovementEntityFactory._();

  static SearchBuyMovementDataParamsEntity makeSearchParams({
    List<int> enterpriseCodes = const [1],
    DateTime? startDate,
    DateTime? endDate,
    BuyMovementPeriodGrouping? periodGrouping = BuyMovementPeriodGrouping.day,
    bool groupByProduct = false,
    bool groupBySupplier = false,
    String? productName,
    int? topCount,
  }) => SearchBuyMovementDataParamsEntity(
    enterpriseCodes: enterpriseCodes,
    startDate: startDate ?? DateTime.utc(2026, 9),
    endDate: endDate ?? DateTime.utc(2026, 9, 10),
    periodGrouping: periodGrouping,
    groupByProduct: groupByProduct,
    groupBySupplier: groupBySupplier,
    productName: productName,
    topCount: topCount,
  );

  static BuyMovementDataResponseEntity makeResponseEntity({
    SearchBuyMovementDataParamsEntity? searchParameters,
  }) => BuyMovementDataResponseEntity(
    searchParameters: searchParameters ?? makeSearchParams(),
    results: const [
      BuyMovementDataRowEntity(
        product: BuyMovementDataProductEntity(
          code: 10,
          packingCode: 2,
          name: 'Product',
          quantity: 3.5,
        ),
        supplier: BuyMovementDataSupplierEntity(code: 20, name: 'Supplier'),
        totalValue: 42.75,
      ),
    ],
  );
}

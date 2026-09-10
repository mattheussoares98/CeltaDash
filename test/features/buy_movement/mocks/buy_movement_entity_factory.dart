import 'package:celta_dash/features/buy_movement/domain/entities/entities.dart';
import 'package:faker/faker.dart';

class BuyMovementEntityFactory {
  BuyMovementEntityFactory._();

  static SearchBuyMovementDataParamsEntity makeSearchParams({
    List<int>? enterpriseCodes,
    DateTime? startDate,
    DateTime? endDate,
    BuyMovementPeriodGrouping? periodGrouping,
    bool annulPeriodGrouping = false,
    bool? groupByProduct,
    bool? groupBySupplier,
    String? productName,
    int? topCount,
  }) {
    final fakeStartDate = startDate ?? faker.date.dateTime();

    return SearchBuyMovementDataParamsEntity(
      enterpriseCodes:
          enterpriseCodes ?? [faker.randomGenerator.integer(1000, min: 1)],
      startDate: fakeStartDate,
      endDate:
          endDate ??
          fakeStartDate.add(
            Duration(days: faker.randomGenerator.integer(365, min: 1)),
          ),
      periodGrouping: annulPeriodGrouping
          ? null
          : periodGrouping ??
                BuyMovementPeriodGrouping.values[faker.randomGenerator.integer(
                  BuyMovementPeriodGrouping.values.length,
                )],
      groupByProduct:
          groupByProduct ??
          (productName != null ||
              topCount != null ||
              faker.randomGenerator.boolean()),
      groupBySupplier: groupBySupplier ?? faker.randomGenerator.boolean(),
      productName: productName,
      topCount: topCount,
    );
  }

  static BuyMovementDataResponseEntity makeResponseEntity({
    SearchBuyMovementDataParamsEntity? searchParameters,
  }) => BuyMovementDataResponseEntity(
    searchParameters: searchParameters ?? makeSearchParams(),
    results: [
      BuyMovementDataRowEntity(
        product: BuyMovementDataProductEntity(
          code: faker.randomGenerator.integer(1000, min: 1),
          packingCode: faker.randomGenerator.integer(100, min: 1),
          name: faker.food.dish(),
          quantity: faker.randomGenerator.decimal(min: 1),
        ),
        supplier: BuyMovementDataSupplierEntity(
          code: faker.randomGenerator.integer(1000, min: 1),
          name: faker.company.name(),
        ),
        totalValue: faker.randomGenerator.decimal(min: 1),
      ),
    ],
  );
}

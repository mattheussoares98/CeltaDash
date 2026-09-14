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
    bool? groupByEnterprise,
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
      groupByEnterprise: groupByEnterprise ?? false,
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
    List<BuyMovementDataRowEntity>? results,
  }) => BuyMovementDataResponseEntity(
    searchParameters: searchParameters ?? makeSearchParams(),
    results: results ?? [makeDataRowEntity()],
  );

  static BuyMovementDataRowEntity makeDataRowEntity({
    int? enterpriseCode,
    DateTime? date,
    bool withProduct = true,
    bool withSupplier = true,
    num? totalValue,
  }) => BuyMovementDataRowEntity(
    enterpriseCode: enterpriseCode,
    date: date,
    product: withProduct
        ? BuyMovementDataProductEntity(
            code: faker.randomGenerator.integer(1000, min: 1),
            packingQuantity: faker.randomGenerator.integer(100, min: 1),
            packingAbbreviation: faker.lorem.word().substring(0, 3),
            priceLookupCode: faker.randomGenerator
                .integer(1000, min: 1)
                .toString(),
            name: faker.food.dish(),
            quantity: faker.randomGenerator.decimal(min: 1),
          )
        : null,
    supplier: withSupplier
        ? BuyMovementDataSupplierEntity(
            code: faker.randomGenerator.integer(1000, min: 1),
            name: faker.company.name(),
          )
        : null,
    totalValue: totalValue ?? faker.randomGenerator.decimal(min: 1),
  );
}

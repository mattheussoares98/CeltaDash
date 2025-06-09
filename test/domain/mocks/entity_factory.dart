import 'package:celta_dash/domain/entities/entities.dart';
import 'package:celta_dash/domain/usecases/usecases.dart';
import 'package:celta_dash/main/builders/builders.dart';
import 'package:faker/faker.dart';

class EntityFactory {
  EntityFactory._();

  static FirebaseEnterpriseEntity makeFirebaseEnterpriseEntity() =>
      FirebaseEnterpriseEntity(
        baseUrl: faker.internet.httpUrl(),
        enterpriseName: faker.company.name(),
        bsUser: makeBsUserEntity(),
        firebaseId: faker.guid.guid(),
        firebaseSubEnterprises: <FirebaseSubEnterpriseEntity>[
          makeFirebaseSubEnterpriseEntity(),
          makeFirebaseSubEnterpriseEntity(),
          makeFirebaseSubEnterpriseEntity(),
        ],
      );

  static FirebaseEnterpriseEntity anullEnterpriseProperties({
    bool? annullbaseUrl,
    bool? anullUserName,
    bool? anullUserAccessKey,
    bool? anullUserCrossIdentity,
    bool? annullEnterpriseName,
    bool? annullSubEnterprises,
    bool? annulFirebaseId,
  }) {
    final enterprise = EnterpriseBuilder.entity;
    final bsUser = BsUserEntity(
      name: anullUserName == true ? null : enterprise?.bsUser?.name,
      AccessKey:
          anullUserAccessKey == true ? null : enterprise?.bsUser?.AccessKey,
      CrossIdentity_Usuario: anullUserCrossIdentity == true
          ? null
          : enterprise?.bsUser?.CrossIdentity_Usuario,
    );
    return FirebaseEnterpriseEntity(
      baseUrl: annullbaseUrl == true ? null : enterprise?.baseUrl,
      bsUser: bsUser,
      enterpriseName:
          annullEnterpriseName == true ? null : enterprise?.enterpriseName,
      firebaseSubEnterprises: annullSubEnterprises == true
          ? null
          : enterprise?.firebaseSubEnterprises,
      firebaseId: annulFirebaseId == true ? null : enterprise?.firebaseId,
    );
  }

  static SaleStatisticsEntity makeSaleStatisticEntity({int? enterpriseId}) =>
      SaleStatisticsEntity(
        QuantityOfProducts: faker.randomGenerator.decimal(),
        TotalRepositionCost: faker.randomGenerator.decimal(),
        LiquidValue: faker.randomGenerator.decimal(),
        Year: faker.randomGenerator.integer(3000),
        Month: faker.randomGenerator.integer(12, min: 1),
        Date: faker.date.dateTime(),
        Hour: faker.randomGenerator.integer(23, min: 0),
        Product: faker.food.dish(),
        ProductDepartment: faker.food.cuisine(),
        ProductSection: faker.food.restaurant(),
        PaymentFinalization: faker.lorem.word(),
        PaymentModality: faker.lorem.word(),
        EnterpriseFantasyName: faker.company.name(),
        EnterpriseId: enterpriseId ?? faker.randomGenerator.integer(100),
        EnterprisePersonalizedCode:
            faker.randomGenerator.integer(10).toString(),
        QuantitySales: faker.randomGenerator.integer(100),
        CashierOperator: faker.person.name(),
        Seller: faker.person.name(),
      );

  static BsUserEntity makeBsUserEntity() => BsUserEntity(
        name: faker.person.name(),
        AccessKey: faker.guid.guid(),
        CrossIdentity_Usuario: faker.guid.guid(),
      );

  static EcEnterpriseEntity makeEcEnterpriseEntity({int? id}) =>
      EcEnterpriseEntity(
        id: id ?? faker.randomGenerator.integer(100),
        name: faker.company.name(),
        personalizedCode: faker.randomGenerator.integer(10).toString(),
        cnpj: faker.guid.guid(),
      );

  static FirebaseSubEnterpriseEntity makeFirebaseSubEnterpriseEntity({
    bool? enabled,
    int? id,
  }) =>
      FirebaseSubEnterpriseEntity(
        cnpj: faker.guid.guid(),
        id: id ?? faker.randomGenerator.integer(100),
        name: faker.company.name(),
        personalizedCode: faker.randomGenerator.integer(10).toString(),
        enabled: enabled ?? faker.randomGenerator.boolean(),
      );

  static GetEcSaleStatisticsParams makeGetSalesParams() =>
      GetEcSaleStatisticsParams(
        startDate: faker.date.dateTime(),
        endDate: faker.date.dateTime(),
        enterpriseIds: [
          faker.randomGenerator.integer(100),
          faker.randomGenerator.integer(100),
        ],
        groupByCashierOperator: faker.randomGenerator.boolean(),
        groupByDay: faker.randomGenerator.boolean(),
        groupByEnterprise: faker.randomGenerator.boolean(),
        groupByHour: faker.randomGenerator.boolean(),
        groupByMonth: faker.randomGenerator.boolean(),
        groupByPaymentFinalization: faker.randomGenerator.boolean(),
        groupByPaymentModality: faker.randomGenerator.boolean(),
        groupByProduct: faker.randomGenerator.boolean(),
        groupByProductDepartment: faker.randomGenerator.boolean(),
        groupByProductSection: faker.randomGenerator.boolean(),
        groupBySeller: faker.randomGenerator.boolean(),
        groupByYear: faker.randomGenerator.boolean(),
        topCount: faker.randomGenerator.integer(100),
      );

  static SaleMovementEntity makeEcSaleMovementEntity() => SaleMovementEntity(
        Id: faker.randomGenerator.integer(100),
        EnterpriseId: faker.randomGenerator.integer(100),
        FiscalNoteTypeId: faker.randomGenerator.integer(100),
        SellerId: faker.randomGenerator.integer(100),
        DocumentNumber: faker.randomGenerator.string(50),
        CashierNumber: faker.randomGenerator.string(50),
        DateHourOfBilling: faker.date.dateTime(),
        TotalLiquid: faker.randomGenerator.decimal(),
        IsCancelled: faker.randomGenerator.boolean(),
        FiscalNoteType: SaleMovementFiscalNoteEntity(
          Id: faker.randomGenerator.integer(50),
          Name: faker.randomGenerator.string(10),
        ),
        Customer: SaleMovementCustomerEntity(
          SaleMovementId: faker.randomGenerator.integer(100),
          Id: faker.randomGenerator.integer(100),
          Name: faker.person.name(),
          CpfCnpj: faker.guid.guid(),
        ),
        Seller: SaleMovementSellerEntity(
          Id: faker.randomGenerator.integer(99),
          PersonalizedCode: faker.randomGenerator.integer(99).toString(),
          Name: faker.person.name(),
        ),
        Products: [
          SaleMovementProductEntity(
            Quantity: faker.randomGenerator.decimal(),
            UnitValue: faker.randomGenerator.decimal(),
            UnitValueLiquid: faker.randomGenerator.decimal(),
            RepositionCost: faker.randomGenerator.decimal(),
            LiquidCost: faker.randomGenerator.decimal(),
            TotalBrute: faker.randomGenerator.decimal(),
            TotalLiquid: faker.randomGenerator.decimal(),
            TotalDiscounts: faker.randomGenerator.decimal(),
            ProductPackingId: faker.randomGenerator.integer(99),
            Id: faker.randomGenerator.integer(99),
            IsCancelled: faker.randomGenerator.boolean(),
            Product: SaleMovementProductProductEntity(
              Id: faker.randomGenerator.integer(99),
              Plu: faker.guid.guid(),
              Name: faker.food.dish(),
              PackingAbbreviation:
                  faker.randomGenerator.string(2).toUpperCase(),
              PackingQuantity: faker.randomGenerator.decimal(),
            ),
          ),
        ],
        PaymentFinalizations: [
          SaleMovementFinalizationEntity(
            Value: faker.randomGenerator.decimal(),
            QuantityOfPortions: faker.randomGenerator.integer(12),
            DateOfExpiration: faker.date.dateTime(),
            Id: faker.randomGenerator.integer(99),
            Finalization: SaleMovementFinalizationFinalizationEntity(
              Id: faker.randomGenerator.integer(99),
              Name: faker.randomGenerator.string(99),
            ),
          ),
        ],
      );

  static GetEcSaleMovementParams makeGetEcSaleMovementParams({
    DateTime? startDate,
    DateTime? endDate,
    List<int>? enterpriseIds,
  }) =>
      GetEcSaleMovementParams(
        EnterpriseIds: enterpriseIds ??
            [
              faker.randomGenerator.integer(99),
              faker.randomGenerator.integer(99),
            ],
        StartDate: startDate ?? faker.date.dateTime(),
        EndDate: endDate ?? faker.date.dateTime(),
        ActualPage: faker.randomGenerator.integer(10),
        RecordsByPage: faker.randomGenerator.integer(999),
        DocumentNumbers: [
          faker.randomGenerator.integer(1000).toString(),
          faker.randomGenerator.integer(1000).toString(),
          faker.randomGenerator.integer(1000).toString(),
        ],
        MountCustomer: faker.randomGenerator.boolean(),
        MountFiscalNoteType: faker.randomGenerator.boolean(),
        MountPaymentFinalizations: faker.randomGenerator.boolean(),
        MountProducts: faker.randomGenerator.boolean(),
        MountSeller: faker.randomGenerator.boolean(),
        OnlyCancelled: faker.randomGenerator.boolean(),
      );
}

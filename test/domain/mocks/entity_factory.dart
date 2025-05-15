import 'package:celta_plus/domain/entities/entities.dart';
import 'package:celta_plus/main/builders/builders.dart';
import 'package:faker/faker.dart';

class EntityFactory {
  EntityFactory._();

  static FirebaseEnterpriseEntity makeFirebaseEnterpriseEntity() =>
      FirebaseEnterpriseEntity(
        baseUrl: faker.internet.httpUrl(),
        enterpriseName: faker.company.name(),
        bsUser: makeBsUserEntity(),
        subEnterprises: <EnterpriseEntity>[
          makeEnterpriseEntity(),
          makeEnterpriseEntity(),
          makeEnterpriseEntity(),
        ],
      );

  static FirebaseEnterpriseEntity anullEnterpriseProperties({
    bool? annullbaseUrl,
    bool? anullUserName,
    bool? anullUserAccessKey,
    bool? anullUserCrossIdentity,
    bool? annullEnterpriseName,
    bool? annullSubEnterprises, //TODO test this
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
      subEnterprises:
          annullSubEnterprises == true ? null : enterprise?.subEnterprises,
    );
  }

  static SaleMovementEntity makeSaleMovementEntity() => SaleMovementEntity(
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
        EnterpriseId: faker.randomGenerator.integer(100),
        EnterprisePersonalizedCode:
            faker.randomGenerator.integer(10).toString(),
        QuantitySales: faker.randomGenerator.integer(100),
      );

  static BsUserEntity makeBsUserEntity() => BsUserEntity(
        name: faker.person.name(),
        AccessKey: faker.guid.guid(),
        CrossIdentity_Usuario: faker.guid.guid(),
      );

  static EnterpriseEntity makeEnterpriseEntity() => EnterpriseEntity(
        id: faker.randomGenerator.integer(100),
        name: faker.company.name(),
        personalizedCode: faker.randomGenerator.integer(10).toString(),
        cnpj: faker.guid.guid(),
      );
}

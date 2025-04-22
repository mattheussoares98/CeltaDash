import 'package:celta_plus/domain/entities/entities.dart';
import 'package:celta_plus/main/builders/builders.dart';
import 'package:faker/faker.dart';

class EntityFactory {
  EntityFactory._();

  static makeEnterpriseEntity() => EnterpriseEntity(
        ccsUrl: faker.internet.httpUrl(),
        enterpriseName: faker.company.name(),
        bsUser: makeBsUserEntity(),
      );

  static EnterpriseEntity anullEnterpriseProperties({
    bool? annullUrl,
    bool? anullUserName,
    bool? anullUserAccessKey,
    bool? anullUserCrossIdentity,
    bool? annullEnterpriseName,
  }) {
    final enterprise = EnterpriseBuilder.entity;
    final bsUser = BsUserEntity(
      name: anullUserName == true ? null : enterprise?.bsUser?.name,
      AccessKey: anullUserAccessKey == true ? null : enterprise?.bsUser?.AccessKey,
      CrossIdentity_Usuario:
          anullUserCrossIdentity == true ? null : enterprise?.bsUser?.CrossIdentity_Usuario,
    );
    return EnterpriseEntity(
      ccsUrl: annullUrl == true ? null : enterprise?.ccsUrl,
      bsUser: bsUser,
      enterpriseName:
          annullEnterpriseName == true ? null : enterprise?.enterpriseName,
    );
  }

  static makeSaleMovementEntity() => SaleMovementEntity(
        Enterprise: faker.company.name(),
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
      );

  static makeBsUserEntity() => BsUserEntity(
        name: faker.person.name(),
        AccessKey: faker.guid.guid(),
        CrossIdentity_Usuario: faker.guid.guid(),
      );
}

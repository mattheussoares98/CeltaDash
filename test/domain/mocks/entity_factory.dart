import 'package:celta_plus/domain/entities/entities.dart';
import 'package:celta_plus/main/builders/builders.dart';
import 'package:faker/faker.dart';

class EntityFactory {
  EntityFactory._();

  static makeEnterpriseEntity() => EnterpriseEntity(
    ccsUrl: faker.internet.httpUrl(),
    user: faker.person.name(),
    accessKey: faker.guid.guid(),
    enterpriseName: faker.company.name(),
  );

  static EnterpriseEntity anullEnterpriseProperties({
    bool? annullUrl,
    bool? annullUser,
    bool? annullAccessKey,
    bool? annullEnterpriseName,
  }) {
    final enterprise = EnterpriseBuilder.entity;
    return EnterpriseEntity(
      ccsUrl: annullUrl == true ? null : enterprise?.ccsUrl,
      user: annullUser == true ? null : enterprise?.user,
      accessKey: annullAccessKey == true ? null : enterprise?.accessKey,
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
}

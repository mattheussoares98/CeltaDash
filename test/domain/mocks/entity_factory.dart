import 'package:celta_plus/domain/entities/entities.dart';
import 'package:faker/faker.dart';

class EntityFactory {
  EntityFactory._();

  static makeEnterpriseEntity() => EnterpriseEntity(
    url: faker.internet.httpUrl(),
    user: faker.company.name(),
    accessKey: faker.guid.guid(),
  );

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

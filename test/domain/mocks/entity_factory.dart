import 'package:celta_plus/domain/entities/entities.dart';
import 'package:faker/faker.dart';

class EntityFactory {
  EntityFactory._();

  static makeEnterpriseEntity() =>
      EnterpriseEntity(url: faker.internet.httpUrl());

  static makeSaleMovementEntity() => SaleMovementEntity(
    Enterprise: faker.company.name(),
    LiquidValue: faker.randomGenerator.decimal(),
    Year: faker.randomGenerator.integer(10),
    Month: faker.randomGenerator.integer(10),
    Date: faker.date.dateTime(),
    Hour: faker.randomGenerator.integer(10),
    Product: faker.food.dish(),
  );
}

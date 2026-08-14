import 'package:celta_dash/features/home/domain/entities/entities.dart';
import 'package:faker/faker.dart';

class HomeEntityFactory {
  HomeEntityFactory._();

  static HomeEnterpriseEntity makeHomeEnterpriseEntity({
    int? id,
    bool? enabled,
  }) => HomeEnterpriseEntity(
    id: id ?? faker.randomGenerator.integer(100),
    name: faker.company.name(),
    personalizedCode: faker.randomGenerator.integer(10).toString(),
    cnpj: faker.guid.guid(),
    enabled: enabled ?? faker.randomGenerator.boolean(),
  );
}

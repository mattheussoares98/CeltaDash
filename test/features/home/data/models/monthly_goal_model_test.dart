import 'package:celta_dash/features/home/data/models/models.dart';
import 'package:celta_dash/features/home/domain/entities/entities.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final enterpriseId = faker.randomGenerator.integer(100);
  final month = faker.date.dateTime();
  final value = faker.randomGenerator.decimal();
  final userName = faker.person.name();
  final entity = MonthlyGoalEntity(
    enterpriseId: enterpriseId,
    month: month,
    value: value,
    userName: userName,
  );

  test('converts between JSON, model, and entity', () {
    final model = MonthlyGoalModel.fromEntity(entity);
    final fromJson = MonthlyGoalModel.fromJson(
      model.toJson(),
      enterpriseId: enterpriseId,
      month: month,
    );

    expect(fromJson, model);
    expect(fromJson.toEntity(), entity);
    expect(fromJson.toJson(), {'value': value, 'userName': userName});
  });
}

import 'package:celta_dash/features/home/data/models/models.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks/mocks.dart';

void main() {
  test('converts between JSON, model, and entity', () {
    final entity = HomeEntityFactory.makeHomeEnterpriseEntity(enabled: false);
    final model = BSFEnterpriseModel.fromEntity(entity);

    expect(BSFEnterpriseModel.fromJson(model.toJson()).toEntity(), entity);
  });
}

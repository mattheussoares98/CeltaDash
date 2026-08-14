import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/features/home/data/models/models.dart';

abstract class IHomeDatasource {
  Future<List<BSFEnterpriseModel>> getEnterprises(EcParams ecParams);
}

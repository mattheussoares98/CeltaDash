import '../../entities/entities.dart';

abstract class LoadEnterprises {
  Future<List<EnterpriseEntity>> get();
}

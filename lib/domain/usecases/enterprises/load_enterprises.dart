import '../../entities/entities.dart';

abstract class LoadEnterprises {
  Future<List<EnterpriseEntity>> get({
    String? url,
    String? userName,
    String? accessKey,
  });
}

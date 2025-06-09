import '../../entities/entities.dart';

abstract class EcLoadEnterprises {
  Future<List<EcEnterpriseEntity>> get({
    String? url,
    String? userName,
    String? accessKey,
  });
}

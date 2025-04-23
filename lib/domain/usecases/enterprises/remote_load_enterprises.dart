import '../../entities/entities.dart';

abstract class RemoteLoadEnterprises {
  Future<List<BsEnterpriseEntity>> get();
}

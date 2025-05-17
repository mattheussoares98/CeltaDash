import '../../../data/models/models.dart';

abstract class RemoteLogin {
  Future<SoapResponseModel> login({
    required String user,
    required String password,
    String? url,
  });
}

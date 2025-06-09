import '../../../data/models/models.dart';

abstract class BsLogin {
  Future<SoapResponseModel> login({
    required String user,
    required String password,
    String? url,
  });
}

import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../main/builders/builders.dart';
import '../../http/http.dart';
import '../../models/models.dart';

class BsRemoteLoadEnterprises implements LoadEnterprises {
  final HttpClient httpAdapter;

  BsRemoteLoadEnterprises(this.httpAdapter);

  @override
  Future<List<EnterpriseEntity>> get({
    String? url,
    String? userName,
    String? accessKey,
  }) async {
    try {
      final baseUrl = url ?? EnterpriseBuilder.entity?.baseUrl;
      final response = await httpAdapter.request(
        url: "$baseUrl/api/enterprises",
        method: "get",
        headers: {
          "user": userName ?? EnterpriseBuilder.entity?.bsUser?.name,
          "accessKey": accessKey ?? EnterpriseBuilder.entity?.bsUser?.AccessKey,
        },
      );

      return (response as List)
          .map((e) => EnterpriseModel.fromJson(e).toEntity())
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}

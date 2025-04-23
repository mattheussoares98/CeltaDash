import '../../../domain/usecases/usecases.dart';
import '../../../main/builders/builders.dart';
import '../../http/http.dart';
import '../../models/models.dart';

class BsRemoteLoadEnterprises implements RemoteLoadEnterprises {
  final SoapRequest soapAdapter;

  BsRemoteLoadEnterprises(this.soapAdapter);

  @override
  Future<SoapResponseModel> get() async {
    try {
      final baseUrl = EnterpriseBuilder.entity?.baseUrl;
      final crossIdentity =
          EnterpriseBuilder.entity?.bsUser?.CrossIdentity_Usuario;

      return await soapAdapter.post(
        ccsUrl:
            "$baseUrl/ccs", //TODO remove this parameter because always will use enterpriseBuilder
        parameters: {
          "crossIdentity": crossIdentity,
          "simpleSearchValue": "",
          "requestTypeCode": 0,
        },
        typeOfResponse: "GetEnterprisesJsonResponse",
        soapAction: "GetEnterprisesJson",
        serviceASMX: "celtaenterpriseService.asmx",
        typeOfResult: "GetEnterprisesJsonResult",
      );
    } catch (e) {
      rethrow;
    }
  }
}

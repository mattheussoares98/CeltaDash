import '../../../../data/usecases/usecases.dart';
import '../../factories.dart';

RemoteEcLoadEnterprises makeRemoteEcLoadEnterprises() =>
    RemoteEcLoadEnterprises(makeHttpAdapter());

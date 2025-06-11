import '../../../../data/usecases/usecases.dart';
import '../../factories.dart';

RemoteLoadEnterprises makeRemoteLoadEnterprises() =>
    RemoteLoadEnterprises(makeHttpAdapter());

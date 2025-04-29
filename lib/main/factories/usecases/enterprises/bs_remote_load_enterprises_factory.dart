import '../../../../data/usecases/usecases.dart';
import '../../factories.dart';

RemoteLoadEnterprises makeBsRemoteLoadEnterprises() =>
    RemoteLoadEnterprises(makeHttpAdapter());

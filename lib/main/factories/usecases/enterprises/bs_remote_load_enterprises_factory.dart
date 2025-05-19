import '../../../../data/usecases/usecases.dart';
import '../../factories.dart';

BsRemoteLoadEnterprises makeBsRemoteLoadEnterprises() =>
    BsRemoteLoadEnterprises(makeHttpAdapter());

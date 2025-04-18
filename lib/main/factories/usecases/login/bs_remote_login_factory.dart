import '../../../../data/usecases/usecases.dart';
import '../../../../domain/usecases/usecases.dart';
import '../../factories.dart';

RemoteLogin makeBsRemoteLogin() => BsRemoteLogin(makeSoapAdapter());
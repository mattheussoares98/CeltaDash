import '../../../../data/usecases/usecases.dart';
import '../../../../domain/usecases/usecases.dart';
import '../../http/http.dart';

LoadSaleMovements makeRemoteLoadSaleMovements() =>
    RemoteLoadSaleMovements(makeHttpAdapter());

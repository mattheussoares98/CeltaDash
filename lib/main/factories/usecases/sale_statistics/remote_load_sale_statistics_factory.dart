import '../../../../data/usecases/usecases.dart';
import '../../../../domain/usecases/usecases.dart';
import '../../http/http.dart';

LoadSaleStatistics makeRemoteLoadSaleStatistics() =>
    RemoteLoadSaleStatistics(makeHttpAdapter());

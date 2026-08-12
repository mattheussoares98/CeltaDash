import '../../../../data/usecases/usecases.dart';
import '../../factories.dart';

RemoteLoadFinancialTitleData makeRemoteLoadFinancialTitleData() =>
    RemoteLoadFinancialTitleData(makeHttpAdapter());

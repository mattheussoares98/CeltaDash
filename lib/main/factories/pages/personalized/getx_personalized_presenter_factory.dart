import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';
import '../../factories.dart';

PersonalizedPresenter makeGetxPersonalizedPresenter() =>
    GetxPersonalizedPresenter(
      loadSaleStatistics: makeRemoteLoadSaleStatistics(),
    );

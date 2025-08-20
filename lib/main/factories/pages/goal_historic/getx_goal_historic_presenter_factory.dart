import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';
import '../../factories.dart';

GoalHistoricPresenter makeGetxGoalHistoricPresenter() =>
    GetxGoalHistoricPresenter(
      firebaseManager: makeRemoteFirebaseManager(),
      loadSaleStatistics: makeRemoteLoadSaleStatistics(),
    );

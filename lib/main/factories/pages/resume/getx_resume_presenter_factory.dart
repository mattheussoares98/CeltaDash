import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';
import '../../factories.dart';

ResumePresenter makeGetxResumePresenter() => GetxResumePresenter(
      navigateTo: makeGetxNavigateTo(),
      loadSaleStatistics: makeRemoteLoadSaleStatistics(),
      firebaseManager: makeRemoteFirebaseManager(),
    );

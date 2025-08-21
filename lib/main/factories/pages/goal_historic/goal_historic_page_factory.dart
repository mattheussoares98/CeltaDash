import '../../../../ui/pages/pages.dart';
import '../../factories.dart';

HistoricGoalPage makeGoalHistoricPage() => HistoricGoalPage(
      presenter: makeGetxGoalHistoricPresenter(),
    );

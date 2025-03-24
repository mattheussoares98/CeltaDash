import 'package:get/get.dart';

import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';

class GetxResumePresenter extends GetxController implements ResumePresenter {
  final NavigateTo navigateTo;

  GetxResumePresenter({required this.navigateTo});

  @override
  void goToDailyAnalysisPage() {
    navigateTo.navigate(pageRoute: PageRoutes.dailyAnalysis);
  }

  @override
  void goToProfitabillityPage() {
    navigateTo.navigate(pageRoute: PageRoutes.profitability);
  }

  @override
  void goToSectionsPage() {
    navigateTo.navigate(pageRoute: PageRoutes.sections);
  }

  @override
  void goToSetGoalPage() {
    navigateTo.navigate(pageRoute: PageRoutes.setGoal);
  }

  @override
  void goToTypesPage() {
    navigateTo.navigate(pageRoute: PageRoutes.types);
  }
}

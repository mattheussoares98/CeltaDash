import 'package:get/get.dart';

import '../../domain/usecases/usecases.dart';
import '../../ui/pages/pages.dart';

class GetxResumePresenter extends GetxController implements ResumePresenter {
  final NavigateTo navigateTo;

  GetxResumePresenter({required this.navigateTo});

  @override
  void goToDailyAnalysisPage() {}

  @override
  void goToProfitabillityPage() {}

  @override
  void goToSectionsPage() {}

  @override
  void goToSetGoalPage() {}

  @override
  void goToTypesPage() {}
}

import 'package:get/get.dart';

import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';

class GetxLoginPresenter extends GetxController implements LoginPresenter {
  final NavigateTo navigateTo;

  GetxLoginPresenter({required this.navigateTo});

  @override
  Future<void> login({required String email, required String password}) async {
    navigateTo.navigate(pageRoute: PageRoutes.home, clear: true);
  }
}

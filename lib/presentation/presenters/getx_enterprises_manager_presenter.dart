import 'package:get/get.dart';

import '../../domain/usecases/usecases.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

class GetxEnterprisesManagerPresenter extends GetxController
    with ErrorHandling, LoadingManager, UIErrorManager
    implements EnterprisesManagerPresenter {
  final NavigateTo navigateTo;
  final BsLogin bsLogin;
  final FirebaseManager firebaseManager;
  final LocalStorage localStorage;

  GetxEnterprisesManagerPresenter({
    required this.navigateTo,
    required this.bsLogin,
    required this.firebaseManager,
    required this.localStorage,
  });
}

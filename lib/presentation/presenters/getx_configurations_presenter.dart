import 'package:get/get.dart';

import '../../domain/usecases/usecases.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

class GetxConfigurationsPresenter extends GetxController
    with UIErrorManager, LoadingManager
    implements ConfigurationsPresenter {
  final NavigateTo navigateTo;

  GetxConfigurationsPresenter({
    required this.navigateTo,
  });

  @override
  Future<void> doLogout() async {}
}

import 'package:celta_dash/features/home/presentation/presentation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FakeHomeController extends HomeController {
  FakeHomeController(this.homeState);

  final HomeState homeState;

  @override
  Future<HomeState> build() async => homeState;

  void updateState(HomeState value) => state = AsyncValue.data(value);
}

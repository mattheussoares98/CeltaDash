import 'package:celta_dash/features/home/presentation/presentation.dart';

class FakeHomeController extends HomeController {
  FakeHomeController(this.homeState);

  final HomeState homeState;

  @override
  Future<HomeState> build() async => homeState;
}

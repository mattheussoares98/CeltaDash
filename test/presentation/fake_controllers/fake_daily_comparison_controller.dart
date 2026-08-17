import 'package:celta_dash/features/home/presentation/presentation.dart';

class FakeDailyComparisonController extends DailyComparisonController {
  FakeDailyComparisonController(this.initialState);

  final DailyComparisonState initialState;

  @override
  Future<DailyComparisonState> build(int enterpriseId) async => initialState;
}

import 'package:celta_dash/features/home/presentation/presentation.dart';

class FakeDailyComparisonController extends DailyComparisonController {
  FakeDailyComparisonController(this.value);

  final DailyComparisonState value;

  @override
  Future<DailyComparisonState> build(int enterpriseId) async => value;
}

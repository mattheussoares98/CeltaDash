import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'goal_historic_year_controller.g.dart';

@riverpod
class GoalHistoricYearController extends _$GoalHistoricYearController {
  @override
  int build() {
    final now = DateTime.now();
    return now.year < 2025 ? 2025 : now.year;
  }

  void selectYear(int year) {
    if (year < 2025) return;
    state = year;
  }
}

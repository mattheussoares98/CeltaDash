import 'package:celta_dash/features/sales_features/presentation/models/models.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'compare_days_dates_controller.g.dart';

const _error = 'Os dias selecionados devem ser diferentes';

@riverpod
class CompareDaysDatesController extends _$CompareDaysDatesController {
  @override
  CompareDaysDatesState build() {
    final now = DateTime.now();
    return CompareDaysDatesState(
      firstDay: DateTime(now.year, now.month, now.day - 1),
      secondDay: DateTime(now.year, now.month, now.day),
    );
  }

  String? selectFirstDay(DateTime date) {
    final selectedDate = _dateOnly(date);
    if (selectedDate == state.secondDay) {
      return _error.hardcoded;
    }
    state = state.copyWith(firstDay: selectedDate);
    return null;
  }

  String? selectSecondDay(DateTime date) {
    final selectedDate = _dateOnly(date);
    if (selectedDate == state.firstDay) {
      return _error.hardcoded;
    }
    state = state.copyWith(secondDay: selectedDate);
    return null;
  }

  DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);
}

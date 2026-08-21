// lib/features/compare_months/presentation/controllers/compare_months_dates_controller.dart
import 'package:celta_dash/features/compare_months/presentation/models/models.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'compare_months_dates_controller.g.dart';

const _samePeriodError = 'Os meses selecionados devem ser diferentes';
const _futureMonthError = 'Não é possível selecionar um mês futuro';

@riverpod
class CompareMonthsDatesController extends _$CompareMonthsDatesController {
  @override
  CompareMonthsDatesState build() {
    final now = DateTime.now();
    return CompareMonthsDatesState(
      firstMonth: DateTime(now.year, now.month - 1),
      secondMonth: DateTime(now.year, now.month),
    );
  }

  String? selectFirstMonth(DateTime date) {
    final selectedMonth = _monthOnly(date);
    if (_isFuture(selectedMonth)) {
      return _futureMonthError.hardcoded;
    }
    if (selectedMonth == state.secondMonth) {
      return _samePeriodError.hardcoded;
    }
    state = state.copyWith(firstMonth: selectedMonth);
    return null;
  }

  String? selectSecondMonth(DateTime date) {
    final selectedMonth = _monthOnly(date);
    if (_isFuture(selectedMonth)) {
      return _futureMonthError.hardcoded;
    }
    if (selectedMonth == state.firstMonth) {
      return _samePeriodError.hardcoded;
    }
    state = state.copyWith(secondMonth: selectedMonth);
    return null;
  }

  bool _isFuture(DateTime date) {
    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month);
    return date.isAfter(currentMonth);
  }

  DateTime _monthOnly(DateTime date) => DateTime(date.year, date.month);
}

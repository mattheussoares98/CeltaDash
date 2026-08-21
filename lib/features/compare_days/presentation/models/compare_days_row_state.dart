import 'package:equatable/equatable.dart';

class CompareDaysRowState extends Equatable {
  const CompareDaysRowState({
    required this.hour,
    required this.firstDayValue,
    required this.secondDayValue,
  });

  final int hour;
  final num firstDayValue;
  final num secondDayValue;

  num get percentageDifference {
    if (firstDayValue == 0 && secondDayValue == 0) return 0;
    if (firstDayValue == 0) return -100;
    return ((firstDayValue - secondDayValue) / firstDayValue) * 100;
  }

  @override
  List<Object?> get props => [hour, firstDayValue, secondDayValue];
}

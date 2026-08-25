import 'package:equatable/equatable.dart';

class CompareDaysDatesState extends Equatable {
  const CompareDaysDatesState({
    required this.firstDay,
    required this.secondDay,
  });

  final DateTime firstDay;
  final DateTime secondDay;

  CompareDaysDatesState copyWith({DateTime? firstDay, DateTime? secondDay}) =>
      CompareDaysDatesState(
        firstDay: firstDay ?? this.firstDay,
        secondDay: secondDay ?? this.secondDay,
      );

  @override
  List<Object?> get props => [firstDay, secondDay];
}

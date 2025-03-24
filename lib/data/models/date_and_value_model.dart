import 'package:equatable/equatable.dart';

class DateAndValueModel extends Equatable {
  final double value;
  final DateTime date;

  const DateAndValueModel({required this.value, required this.date});

  @override
  List<Object?> get props => [value, date];
}

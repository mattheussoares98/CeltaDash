import 'package:equatable/equatable.dart';

class MonthlyGoalEntity extends Equatable {
  const MonthlyGoalEntity({
    required this.enterpriseId,
    required this.month,
    required this.value,
    required this.userName,
  });

  final int enterpriseId;
  final DateTime month;
  final double value;
  final String userName;

  MonthlyGoalEntity copyWith({
    int? enterpriseId,
    DateTime? month,
    double? value,
    String? userName,
  }) => MonthlyGoalEntity(
    enterpriseId: enterpriseId ?? this.enterpriseId,
    month: month ?? this.month,
    value: value ?? this.value,
    userName: userName ?? this.userName,
  );

  @override
  List<Object> get props => [enterpriseId, month, value, userName];
}

import 'package:equatable/equatable.dart';

class FirebaseGoalEntity extends Equatable {
  final int enterpriseId;
  final int year;
  final int month;
  final double value;
  final String? goalId;
  final String userName;

  const FirebaseGoalEntity({
    required this.enterpriseId,
    required this.year,
    required this.month,
    required this.value,
    required this.goalId,
    required this.userName,
  });

  @override
  List<Object?> get props =>
      [enterpriseId, year, month, value, goalId, userName];

  FirebaseGoalEntity copyWith({
    int? enterpriseId,
    int? year,
    int? month,
    double? value,
    String? goalId,
    String? userName,
  }) =>
      FirebaseGoalEntity(
        enterpriseId: enterpriseId ?? this.enterpriseId,
        year: year ?? this.year,
        month: month ?? this.month,
        value: value ?? this.value,
        goalId: goalId ?? this.goalId,
        userName: userName ?? this.userName,
      );
}

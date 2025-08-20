import 'package:equatable/equatable.dart';

class FirebaseGoalEntity extends Equatable {
  final int enterpriseId;
  final int year;
  final int month;
  final double value;

  const FirebaseGoalEntity({
    required this.enterpriseId,
    required this.year,
    required this.month,
    required this.value,
  });

  @override
  List<Object?> get props => [enterpriseId, year, month, value];
}

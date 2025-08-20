import '../../../domain/entities/entities.dart';

class FirebaseGoalViewModel {
  final FirebaseGoalEntity goal;

  const FirebaseGoalViewModel(this.goal);

  String get enterpriseId => goal.enterpriseId.toString();
  double get value => goal.value;
  String get displayPeriod => '${goal.month}/${goal.year}';
}

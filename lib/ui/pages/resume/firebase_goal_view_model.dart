import '../../../domain/entities/entities.dart';

class FirebaseGoalViewModel {
  final FirebaseGoalEntity? goal;

  const FirebaseGoalViewModel(this.goal);

  bool get isWrittenByUser => goal != null;
  String? get enterpriseId => goal?.enterpriseId.toString();
  String? get value => goal?.value.toString();
  String get displayPeriod => '${goal?.month}/${goal?.year}';
}

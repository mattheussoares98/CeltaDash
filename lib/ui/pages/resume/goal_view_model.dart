import '../../../domain/entities/entities.dart';

class GoalViewModel {
  final FirebaseGoalEntity? goalEntity;

  const GoalViewModel(this.goalEntity);

  bool get isWrittenByUser => goalEntity != null;
  String? get enterpriseId => goalEntity?.enterpriseId.toString();
  String? get value => goalEntity?.value.toString();
  String get displayPeriod => '${goalEntity?.month}/${goalEntity?.year}';
}

import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';

class GoalViewModel extends Equatable {
  final FirebaseGoalEntity? goalEntity;

  const GoalViewModel(this.goalEntity);

  bool get isWrittenByUser => goalEntity != null;
  String? get enterpriseId => goalEntity?.enterpriseId.toString();
  String? get value => goalEntity?.value.toString();
  String? get userName => goalEntity?.userName;
  String get displayPeriod => '${goalEntity?.month}/${goalEntity?.year}';

  @override
  List<Object?> get props => [goalEntity];
}

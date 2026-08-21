import 'package:celta_dash/features/home/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class MonthlyGoalModel extends Equatable {
  const MonthlyGoalModel({
    required this.enterpriseId,
    required this.month,
    required this.value,
    required this.userName,
  });

  final int enterpriseId;
  final DateTime month;
  final double value;
  final String userName;

  factory MonthlyGoalModel.fromJson(
    Map json, {
    required int enterpriseId,
    required DateTime month,
  }) => MonthlyGoalModel(
    enterpriseId: enterpriseId,
    month: month,
    value: (json['value'] as num).toDouble(),
    userName: json['userName'] as String? ?? '',
  );

  factory MonthlyGoalModel.fromEntity(MonthlyGoalEntity entity) =>
      MonthlyGoalModel(
        enterpriseId: entity.enterpriseId,
        month: entity.month,
        value: entity.value,
        userName: entity.userName,
      );

  Map toJson() => {'value': value, 'userName': userName};

  MonthlyGoalEntity toEntity() => MonthlyGoalEntity(
    enterpriseId: enterpriseId,
    month: month,
    value: value,
    userName: userName,
  );

  @override
  List<Object> get props => [enterpriseId, month, value, userName];
}

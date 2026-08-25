import '../../domain/entities/entities.dart';

class FirebaseGoalModel extends FirebaseGoalEntity {
  const FirebaseGoalModel({
    required super.enterpriseId,
    required super.year,
    required super.month,
    required super.value,
    required super.goalId,
    required super.userName,
  });

  factory FirebaseGoalModel.fromMapEntry(MapEntry<String, dynamic> entry) {
    // The key is the field name, e.g., "11-2024-11"
    final String key = entry.key;
    final parts = key.split('-');

    if (parts.length != 3) {
      throw FormatException(
        'Invalid field key format. Expected "enterpriseId-yyyy-MM", but got "$key".',
      );
    }

    final int enterpriseId = int.parse(parts[0]);
    final int year = int.parse(parts[1]);
    final int month = int.parse(parts[2]);

    // The value is the map associated with the key, e.g., {value: 100}
    final values = entry.value as Map<String, dynamic>;
    final double value = (values['value'] as num).toDouble();
    final String userName = values['userName'] as String? ?? '';

    return FirebaseGoalModel(
      goalId: key,
      enterpriseId: enterpriseId,
      year: year,
      month: month,
      value: value,
      userName: userName,
    );
  }

}

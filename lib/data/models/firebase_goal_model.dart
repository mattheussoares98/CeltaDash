import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/entities.dart';

class FirebaseGoalModel extends FirebaseGoalEntity {
  const FirebaseGoalModel({
    required super.enterpriseId,
    required super.year,
    required super.month,
    required super.value,
  });

  factory FirebaseGoalModel.fromFirestoreDocument(DocumentSnapshot doc) {
    final String key = doc.id;
    final parts = key.split('-');

    if (parts.length != 3) {
      throw FormatException(
        'Invalid document ID format. Expected "enterpriseId-yyyy-MM", but got "$key".',
      );
    }

    final int enterpriseId = int.parse(parts[0]);
    final int year = int.parse(parts[1]);
    final int month = int.parse(parts[2]);

    final data = doc.data() as Map<String, dynamic>;

    final double value = (data['value'] as num).toDouble();

    return FirebaseGoalModel(
      enterpriseId: enterpriseId,
      year: year,
      month: month,
      value: value,
    );
  }
}

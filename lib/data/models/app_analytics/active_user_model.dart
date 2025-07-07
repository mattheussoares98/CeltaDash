import '../../../domain/entities/entities.dart';

class ActiveUserModel extends ActiveUserEntity {
  const ActiveUserModel({
    required super.userName,
    required super.platform,
    required super.lastActive,
  });

  factory ActiveUserModel.fromJson(Map<String, dynamic> json) {
    return ActiveUserModel(
      userName: json['userName'],
      platform: json['platform'],
      lastActive: DateTime.parse(json['lastActive']),
    );
  }

  Map<String, dynamic> toJson() => {
        'userName': userName,
        'platform': platform,
        'lastActive': lastActive.toIso8601String(),
      };

  factory ActiveUserModel.fromEntity(ActiveUserEntity entity) {
    return ActiveUserModel(
      userName: entity.userName,
      platform: entity.platform,
      lastActive: entity.lastActive,
    );
  }
}

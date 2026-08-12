import 'package:celta_dash/domain/entities/entities.dart';

class ActiveUserModel extends ActiveUserEntity {
  const ActiveUserModel({
    required super.userName,
    required super.platform,
  });

  factory ActiveUserModel.fromJson(Map<String, dynamic> json) {
    return ActiveUserModel(
      userName: json['userName'],
      platform: json['platform'],
    );
  }

  Map<String, dynamic> toJson() => {
        'userName': userName,
        'platform': platform,
      };

  factory ActiveUserModel.fromEntity(ActiveUserEntity entity) {
    return ActiveUserModel(
      userName: entity.userName,
      platform: entity.platform,
    );
  }
}

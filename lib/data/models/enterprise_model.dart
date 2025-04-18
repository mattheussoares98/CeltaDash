import 'package:equatable/equatable.dart';

import '../../domain/entities/entities.dart';

class EnterpriseModel extends Equatable {
  final String? url;
  final String? user;
  final String? accessKey;

  const EnterpriseModel({
    required this.url,
    required this.user,
    required this.accessKey,
  });

  @override
  List<Object?> get props => [url, user, accessKey];

  factory EnterpriseModel.fromJson(Map json) => EnterpriseModel(
    url: json['url'],
    user: json['user'],
    accessKey: json['accessKey'],
  );

  factory EnterpriseModel.fromEntity(EnterpriseEntity entity) =>
      EnterpriseModel(
        url: entity.url,
        user: entity.user,
        accessKey: entity.accessKey,
      );

  Map<String, dynamic> toJson() => {
    'url': url,
    'user': user,
    'accessKey': accessKey,
  };

  EnterpriseEntity toEntity() =>
      EnterpriseEntity(url: url, user: user, accessKey: accessKey);
}

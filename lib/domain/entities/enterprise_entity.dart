import 'package:equatable/equatable.dart';

class EnterpriseEntity extends Equatable {
  final String? ccsUrl;
  final String? user;
  final String? accessKey;
  final String? enterpriseName;

  const EnterpriseEntity({
    required this.ccsUrl,
    required this.user,
    required this.accessKey,
    required this.enterpriseName,
  });

  @override
  List<Object?> get props => [ccsUrl, user, accessKey, enterpriseName];
}

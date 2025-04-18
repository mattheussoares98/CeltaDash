import 'package:equatable/equatable.dart';

class EnterpriseEntity extends Equatable {
  final String? url;
  final String? user;
  final String? accessKey;

  const EnterpriseEntity({
    required this.url,
    required this.user,
    required this.accessKey,
  });

  @override
  List<Object?> get props => [url, user, accessKey];
}

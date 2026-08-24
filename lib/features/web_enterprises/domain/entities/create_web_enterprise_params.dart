import 'package:equatable/equatable.dart';

class CreateWebEnterpriseParams extends Equatable {
  final String baseUrl;
  final String enterpriseName;
  final String user;
  final String password;

  const CreateWebEnterpriseParams({
    required this.baseUrl,
    required this.enterpriseName,
    required this.user,
    required this.password,
  });

  String get normalizedBaseUrl => baseUrl.trim().toLowerCase();

  String get normalizedEnterpriseName =>
      enterpriseName.trim().toLowerCase().replaceAll(RegExp(r'\s+'), '');

  @override
  List<Object?> get props => [baseUrl, enterpriseName, user, password];
}

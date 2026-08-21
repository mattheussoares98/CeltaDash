import 'package:equatable/equatable.dart';

class AddEnterpriseParams extends Equatable {
  const AddEnterpriseParams({
    required this.enterpriseName,
    required this.user,
    required this.password,
  });

  final String enterpriseName;
  final String user;
  final String password;

  @override
  List<Object?> get props => [enterpriseName, user, password];
}

// lib/features/login/domain/entities/login_params.dart
import 'package:equatable/equatable.dart';

class LoginParams extends Equatable {
  final String enterpriseName;
  final String user;
  final String password;

  const LoginParams({
    required this.enterpriseName,
    required this.user,
    required this.password,
  });

  @override
  List<Object?> get props => [enterpriseName, user, password];
}

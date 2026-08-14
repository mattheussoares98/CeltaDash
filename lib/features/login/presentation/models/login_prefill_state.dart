import 'package:equatable/equatable.dart';

class LoginPrefillState extends Equatable {
  const LoginPrefillState({this.enterpriseName, this.username});

  final String? enterpriseName;
  final String? username;

  @override
  List<Object?> get props => [enterpriseName, username];
}

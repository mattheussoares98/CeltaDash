import 'package:equatable/equatable.dart';

class ActiveUserEntity extends Equatable {
  final String userName;
  final String platform;
  final DateTime lastActive;

  const ActiveUserEntity({
    required this.userName,
    required this.platform,
    required this.lastActive,
  });

  @override
  List<Object?> get props => [userName, platform, lastActive];
}

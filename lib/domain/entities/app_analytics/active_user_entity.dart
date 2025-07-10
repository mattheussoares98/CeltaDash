import 'package:equatable/equatable.dart';

class ActiveUserEntity extends Equatable {
  final String userName;
  final String platform;

  const ActiveUserEntity({
    required this.userName,
    required this.platform,
  });

  @override
  List<Object?> get props => [
        userName,
        platform,
      ];
}

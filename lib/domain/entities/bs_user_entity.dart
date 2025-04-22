import 'package:equatable/equatable.dart';

class BsUserEntity extends Equatable {
  final String? name;
  final String? AccessKey;
  final String? CrossIdentity_Usuario;

  const BsUserEntity({
    required this.name,
    required this.AccessKey,
    required this.CrossIdentity_Usuario,
  });

  @override
  List<Object?> get props => [
        name,
        AccessKey,
        CrossIdentity_Usuario,
      ];
}

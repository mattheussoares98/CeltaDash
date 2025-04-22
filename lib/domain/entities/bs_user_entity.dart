import 'package:equatable/equatable.dart';

class BsUserEntity extends Equatable {
  final String? name;
  final String? accessKey;

  const BsUserEntity({
    required this.name,
    required this.accessKey,
  });

  @override
  List<Object?> get props => [name, accessKey];
}

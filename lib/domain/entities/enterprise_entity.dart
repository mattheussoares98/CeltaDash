import 'package:equatable/equatable.dart';

class EnterpriseEntity extends Equatable {
  final String? url;

  const EnterpriseEntity({required this.url});

  @override
  List<Object?> get props => [url];
}

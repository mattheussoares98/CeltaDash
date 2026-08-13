import 'package:equatable/equatable.dart';

class CrashlyticsCustomKeyEntity extends Equatable {
  final String key;
  final Object value;

  const CrashlyticsCustomKeyEntity({required this.key, required this.value});

  @override
  List<Object?> get props => [key, value];
}

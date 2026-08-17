import 'package:equatable/equatable.dart';

class GroupOfStoresEnterpriseState extends Equatable {
  const GroupOfStoresEnterpriseState({
    required this.id,
    required this.name,
    required this.liquidValue,
  });

  final int? id;
  final String name;
  final double liquidValue;

  @override
  List<Object?> get props => [id, name, liquidValue];
}

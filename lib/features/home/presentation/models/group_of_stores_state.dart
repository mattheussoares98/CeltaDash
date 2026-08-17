import 'package:celta_dash/features/home/presentation/models/models.dart';
import 'package:equatable/equatable.dart';

class GroupOfStoresState extends Equatable {
  const GroupOfStoresState({required this.enterprises});

  final List<GroupOfStoresEnterpriseState> enterprises;

  bool get hasMultipleEnterprises => enterprises.length > 1;

  @override
  List<Object?> get props => [enterprises];
}

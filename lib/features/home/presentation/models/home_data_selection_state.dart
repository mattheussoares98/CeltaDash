import 'package:celta_dash/core/domain/domain.dart';
import 'package:equatable/equatable.dart';

class HomeDataSelectionState extends Equatable {
  const HomeDataSelectionState({
    required this.appMode,
    required this.enterpriseId,
    required this.selectedDate,
  });

  final AppMode appMode;
  final int enterpriseId;
  final DateTime selectedDate;

  @override
  List<Object> get props => [appMode, enterpriseId, selectedDate];
}

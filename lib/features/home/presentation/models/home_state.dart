import 'package:celta_dash/core/domain/domain.dart';
import 'package:equatable/equatable.dart';

class HomeState extends Equatable {
  const HomeState({
    required this.selectedDate,
    required this.selectedEnterpriseId,
    required this.appMode,
  });

  factory HomeState.initial({required AppMode appMode}) => HomeState(
    selectedDate: DateTime.now(),
    selectedEnterpriseId: null,
    appMode: appMode,
  );

  final DateTime selectedDate;
  final int? selectedEnterpriseId;
  final AppMode appMode;

  HomeState copyWith({
    DateTime? selectedDate,
    int? selectedEnterpriseId,
    AppMode? appMode,
    bool clearSelectedEnterpriseId = false,
  }) => HomeState(
    selectedDate: selectedDate ?? this.selectedDate,
    selectedEnterpriseId: clearSelectedEnterpriseId
        ? null
        : selectedEnterpriseId ?? this.selectedEnterpriseId,
    appMode: appMode ?? this.appMode,
  );

  @override
  List<Object?> get props => [selectedDate, selectedEnterpriseId, appMode];
}

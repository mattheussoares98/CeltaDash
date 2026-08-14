import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/features/home/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class HomeState extends Equatable {
  const HomeState({
    required this.selectedDate,
    required this.enterprises,
    required this.selectedEnterpriseId,
    required this.appMode,
    required this.isRefreshing,
    required this.selectionError,
  });

  factory HomeState.initial({required AppMode appMode}) => HomeState(
    selectedDate: DateTime.now(),
    enterprises: const [],
    selectedEnterpriseId: null,
    appMode: appMode,
    isRefreshing: false,
    selectionError: null,
  );

  final DateTime selectedDate;
  final List<HomeEnterpriseEntity> enterprises;
  final int? selectedEnterpriseId;
  final AppMode appMode;
  final bool isRefreshing;
  final String? selectionError;

  HomeEnterpriseEntity? get selectedEnterprise {
    for (final enterprise in enterprises) {
      if (enterprise.id == selectedEnterpriseId) return enterprise;
    }
    return null;
  }

  bool get selectedEnterpriseIsEnabled => selectedEnterprise?.enabled == true;

  HomeState copyWith({
    DateTime? selectedDate,
    List<HomeEnterpriseEntity>? enterprises,
    int? selectedEnterpriseId,
    AppMode? appMode,
    bool? isRefreshing,
    String? selectionError,
    bool clearSelectionError = false,
    bool clearSelectedEnterpriseId = false,
  }) => HomeState(
    selectedDate: selectedDate ?? this.selectedDate,
    enterprises: enterprises ?? this.enterprises,
    selectedEnterpriseId: clearSelectedEnterpriseId
        ? null
        : selectedEnterpriseId ?? this.selectedEnterpriseId,
    appMode: appMode ?? this.appMode,
    isRefreshing: isRefreshing ?? this.isRefreshing,
    selectionError: clearSelectionError
        ? null
        : selectionError ?? this.selectionError,
  );

  @override
  List<Object?> get props => [
    selectedDate,
    enterprises,
    selectedEnterpriseId,
    appMode,
    isRefreshing,
    selectionError,
  ];
}

import 'package:celta_dash/core/domain/domain.dart';
import 'package:equatable/equatable.dart';

class EnterprisesManagerState extends Equatable {
  const EnterprisesManagerState({
    required this.enterprises,
    required this.selectedEnterpriseId,
    required this.selectedEnterpriseName,
    this.isProcessing = false,
    this.actionError,
  });

  final List<FirebaseEnterpriseEntity> enterprises;
  final String? selectedEnterpriseId;
  final String? selectedEnterpriseName;
  final bool isProcessing;
  final Object? actionError;

  EnterprisesManagerState copyWith({
    bool? isProcessing,
    Object? actionError,
    bool clearActionError = false,
  }) => EnterprisesManagerState(
    enterprises: enterprises,
    selectedEnterpriseId: selectedEnterpriseId,
    selectedEnterpriseName: selectedEnterpriseName,
    isProcessing: isProcessing ?? this.isProcessing,
    actionError: clearActionError ? null : actionError ?? this.actionError,
  );

  bool isSelected(FirebaseEnterpriseEntity enterprise) {
    if (selectedEnterpriseId != null && enterprise.firebaseId != null) {
      return selectedEnterpriseId == enterprise.firebaseId;
    }
    final normalizedSelectedName = selectedEnterpriseName?.trim().toLowerCase();
    if (normalizedSelectedName == null || normalizedSelectedName.isEmpty) {
      return false;
    }
    return normalizedSelectedName ==
        enterprise.enterpriseName?.trim().toLowerCase();
  }

  @override
  List<Object?> get props => [
    enterprises,
    selectedEnterpriseId,
    selectedEnterpriseName,
    isProcessing,
    actionError,
  ];
}

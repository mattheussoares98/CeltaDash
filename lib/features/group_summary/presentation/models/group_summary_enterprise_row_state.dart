// lib/features/group_summary/presentation/models/group_summary_enterprise_row_state.dart
import 'package:equatable/equatable.dart';

class GroupSummaryEnterpriseRowState extends Equatable {
  const GroupSummaryEnterpriseRowState({
    required this.enterpriseId,
    required this.enterpriseName,
    required this.sales,
    required this.share,
  });

  final int? enterpriseId;
  final String enterpriseName;
  final double sales;
  final double share;

  @override
  List<Object?> get props => [
    enterpriseId,
    enterpriseName,
    sales,
    share,
  ];
}

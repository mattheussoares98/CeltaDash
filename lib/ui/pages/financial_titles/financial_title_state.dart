import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';
import '../../helpers/helpers.dart';
import 'financial_title_status.dart';

class FinancialTitleState extends Equatable {
  final FinancialTitleStatus status;
  final SearchFinancialTitleDataParams? params;
  final FinancialTitleDataResponseEntity? data;
  final UIError? error;
  final DateTime? loadedAt;

  const FinancialTitleState({
    required this.status,
    this.params,
    this.data,
    this.error,
    this.loadedAt,
  });

  @override
  List<Object?> get props => [
        status,
        params,
        data,
        error,
        loadedAt,
      ];
}

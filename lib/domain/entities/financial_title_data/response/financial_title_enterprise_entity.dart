import 'package:equatable/equatable.dart';

/// Enterprise returned by Commerce API.
class FinancialTitleEnterpriseEntity extends Equatable {
  final int? code;
  final String? name;
  final String? fantasyName;

  const FinancialTitleEnterpriseEntity({
    required this.code,
    required this.name,
    required this.fantasyName,
  });

  @override
  List<Object?> get props => [code, name, fantasyName];
}

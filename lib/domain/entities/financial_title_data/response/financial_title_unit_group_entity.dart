import 'package:equatable/equatable.dart';

/// Unit group returned by Commerce API.
class FinancialTitleUnitGroupEntity extends Equatable {
  final int? code;
  final String? name;

  const FinancialTitleUnitGroupEntity({
    required this.code,
    required this.name,
  });

  @override
  List<Object?> get props => [code, name];
}

import 'package:equatable/equatable.dart';

/// Control document returned by Commerce API.
class FinancialTitleControlDocumentEntity extends Equatable {
  final int? code;
  final String? controlCode;
  final num? value;
  final String? ourNumber;
  final int? financialTitlePortionCode;

  const FinancialTitleControlDocumentEntity({
    required this.code,
    required this.controlCode,
    required this.value,
    required this.ourNumber,
    required this.financialTitlePortionCode,
  });

  @override
  List<Object?> get props => [
        code,
        controlCode,
        value,
        ourNumber,
        financialTitlePortionCode,
      ];
}

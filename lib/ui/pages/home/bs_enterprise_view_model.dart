import 'package:equatable/equatable.dart';

class BsEnterpriseViewModel extends Equatable {
  final String? Code;
  final String? PersonalizedCode;
  final String? Name;
  final String? CnpjNumber;
  final String? CodigoInternoVendaMobileModeloPedido;
  final String? UseRetailSale;
  final String? UseWholeSale;
  final String? UseEcommerceSale;
  final String? EnterpriseParticipateEnterpriseGroup;
  final String? ProductCodeSizeOfBalanceLabel;
  final String? ProductCodeWithCheckerDigit;
  final String? InscriptionNumber;

  const BsEnterpriseViewModel({
    required this.Code,
    required this.PersonalizedCode,
    required this.Name,
    required this.CnpjNumber,
    required this.CodigoInternoVendaMobileModeloPedido,
    required this.UseEcommerceSale,
    required this.UseRetailSale,
    required this.UseWholeSale,
    required this.EnterpriseParticipateEnterpriseGroup,
    required this.ProductCodeSizeOfBalanceLabel,
    required this.ProductCodeWithCheckerDigit,
    required this.InscriptionNumber,
  });

  @override
  List<Object?> get props => [
        Code,
        PersonalizedCode,
        Name,
        CnpjNumber,
        CodigoInternoVendaMobileModeloPedido,
        UseEcommerceSale,
        UseRetailSale,
        UseWholeSale,
        EnterpriseParticipateEnterpriseGroup,
        ProductCodeSizeOfBalanceLabel,
        ProductCodeWithCheckerDigit,
        InscriptionNumber,
      ];
}

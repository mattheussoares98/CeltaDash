import 'package:equatable/equatable.dart';

class BsEnterpriseEntity extends Equatable {
  final int? Code;
  final String? PersonalizedCode;
  final String? Name;
  final int? CnpjNumber;
  final int? CodigoInternoVendaMobile_ModeloPedido;
  final bool? useRetailSale;
  final bool? useWholeSale;
  final bool? useEcommerceSale;
  final bool? EnterpriseParticipateEnterpriseGroup;
  final int? ProductCodeSizeOfBalanceLabel;
  final bool? ProductCodeWithCheckerDigit;
  final String? InscriptionNumber;

  const BsEnterpriseEntity({
    required this.Code,
    required this.PersonalizedCode,
    required this.Name,
    required this.CnpjNumber,
    required this.CodigoInternoVendaMobile_ModeloPedido,
    required this.useEcommerceSale,
    required this.useRetailSale,
    required this.useWholeSale,
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
        CodigoInternoVendaMobile_ModeloPedido,
        useEcommerceSale,
        useRetailSale,
        useWholeSale,
        EnterpriseParticipateEnterpriseGroup,
        ProductCodeSizeOfBalanceLabel,
        ProductCodeWithCheckerDigit,
        InscriptionNumber,
      ];
}

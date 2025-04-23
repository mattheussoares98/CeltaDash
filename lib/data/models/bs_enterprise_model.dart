import 'package:celta_plus/ui/helpers/helpers.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/entities.dart';

class BsEnterpriseModel extends Equatable {
  final int? Code;
  final String? PersonalizedCode;
  final String? Name;
  final int? CnpjNumber;
  final int? CodigoInternoVendaMobileModeloPedido;
  final bool? UseRetailSale;
  final bool? UseWholeSale;
  final bool? UseEcommerceSale;
  final bool? EnterpriseParticipateEnterpriseGroup;
  final int? ProductCodeSizeOfBalanceLabel;
  final bool? ProductCodeWithCheckerDigit;
  final String? InscriptionNumber;

  const BsEnterpriseModel({
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

  factory BsEnterpriseModel.fromJson(Map json) => BsEnterpriseModel(
        Code: json['Code'],
        PersonalizedCode: json['PersonalizedCode'],
        Name: json['Name'],
        CnpjNumber: json['CnpjNumber']?.toString().toInt(),
        CodigoInternoVendaMobileModeloPedido:
            json['CodigoInternoVendaMobile_ModeloPedido'],
        UseEcommerceSale: json['useEcommerceSale'],
        UseRetailSale: json['useRetailSale'],
        UseWholeSale: json['useWholeSale'],
        EnterpriseParticipateEnterpriseGroup:
            json['EnterpriseParticipateEnterpriseGroup'],
        ProductCodeSizeOfBalanceLabel: json['ProductCodeSizeOfBalanceLabel'],
        ProductCodeWithCheckerDigit: json['ProductCodeWithCheckerDigit'],
        InscriptionNumber: json['InscriptionNumber'],
      );

  Map<String, dynamic> toJson() => {
        'Code': Code,
        'PersonalizedCode': PersonalizedCode,
        'Name': Name,
        'CnpjNumber': CnpjNumber,
        'CodigoInternoVendaMobile_ModeloPedido':
            CodigoInternoVendaMobileModeloPedido,
        'useEcommerceSale': UseEcommerceSale,
        'useRetailSale': UseRetailSale,
        'useWholeSale': UseWholeSale,
        'EnterpriseParticipateEnterpriseGroup':
            EnterpriseParticipateEnterpriseGroup,
        'ProductCodeSizeOfBalanceLabel': ProductCodeSizeOfBalanceLabel,
        'ProductCodeWithCheckerDigit': ProductCodeWithCheckerDigit,
        'InscriptionNumber': InscriptionNumber,
      };

  factory BsEnterpriseModel.fromEntity(BsEnterpriseEntity entity) =>
      BsEnterpriseModel(
        Code: entity.Code,
        PersonalizedCode: entity.PersonalizedCode,
        Name: entity.Name,
        CnpjNumber: entity.CnpjNumber,
        CodigoInternoVendaMobileModeloPedido:
            entity.CodigoInternoVendaMobile_ModeloPedido,
        UseEcommerceSale: entity.useEcommerceSale,
        UseRetailSale: entity.useRetailSale,
        UseWholeSale: entity.useWholeSale,
        EnterpriseParticipateEnterpriseGroup:
            entity.EnterpriseParticipateEnterpriseGroup,
        ProductCodeSizeOfBalanceLabel: entity.ProductCodeSizeOfBalanceLabel,
        ProductCodeWithCheckerDigit: entity.ProductCodeWithCheckerDigit,
        InscriptionNumber: entity.InscriptionNumber,
      );

  BsEnterpriseEntity toEntity() => BsEnterpriseEntity(
        Code: Code,
        PersonalizedCode: PersonalizedCode,
        Name: Name,
        CnpjNumber: CnpjNumber,
        CodigoInternoVendaMobile_ModeloPedido:
            CodigoInternoVendaMobileModeloPedido,
        useEcommerceSale: UseEcommerceSale,
        useRetailSale: UseRetailSale,
        useWholeSale: UseWholeSale,
        EnterpriseParticipateEnterpriseGroup:
            EnterpriseParticipateEnterpriseGroup,
        ProductCodeSizeOfBalanceLabel: ProductCodeSizeOfBalanceLabel,
        ProductCodeWithCheckerDigit: ProductCodeWithCheckerDigit,
        InscriptionNumber: InscriptionNumber,
      );

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

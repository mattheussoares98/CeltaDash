import 'package:equatable/equatable.dart';

import '../../domain/entities/entities.dart';

class BsEnterpriseModel extends Equatable {
  final int? code;
  final int? personalizedCode;
  final String? name;
  final int? cnpjNumber;
  final int? codigoInternoVendaMobileModeloPedido;
  final bool? useRetailSale;
  final bool? useWholeSale;
  final bool? useEcommerceSale;
  final bool? enterpriseParticipateEnterpriseGroup;
  final int? productCodeSizeOfBalanceLabel;
  final bool? productCodeWithCheckerDigit;
  final String? inscriptionNumber;

  const BsEnterpriseModel({
    required this.code,
    required this.personalizedCode,
    required this.name,
    required this.cnpjNumber,
    required this.codigoInternoVendaMobileModeloPedido,
    required this.useEcommerceSale,
    required this.useRetailSale,
    required this.useWholeSale,
    required this.enterpriseParticipateEnterpriseGroup,
    required this.productCodeSizeOfBalanceLabel,
    required this.productCodeWithCheckerDigit,
    required this.inscriptionNumber,
  });

  factory BsEnterpriseModel.fromJson(Map json) => BsEnterpriseModel(
        code: json['Code'],
        personalizedCode: json['PersonalizedCode'],
        name: json['Name'],
        cnpjNumber: json['CnpjNumber'],
        codigoInternoVendaMobileModeloPedido:
            json['CodigoInternoVendaMobile_ModeloPedido'],
        useEcommerceSale: json['useEcommerceSale'],
        useRetailSale: json['useRetailSale'],
        useWholeSale: json['useWholeSale'],
        enterpriseParticipateEnterpriseGroup:
            json['EnterpriseParticipateEnterpriseGroup'],
        productCodeSizeOfBalanceLabel: json['ProductCodeSizeOfBalanceLabel'],
        productCodeWithCheckerDigit: json['ProductCodeWithCheckerDigit'],
        inscriptionNumber: json['InscriptionNumber'],
      );

  Map<String, dynamic> toJson() => {
        'Code': code,
        'PersonalizedCode': personalizedCode,
        'Name': name,
        'CnpjNumber': cnpjNumber,
        'CodigoInternoVendaMobile_ModeloPedido':
            codigoInternoVendaMobileModeloPedido,
        'useEcommerceSale': useEcommerceSale,
        'useRetailSale': useRetailSale,
        'useWholeSale': useWholeSale,
        'EnterpriseParticipateEnterpriseGroup':
            enterpriseParticipateEnterpriseGroup,
        'ProductCodeSizeOfBalanceLabel': productCodeSizeOfBalanceLabel,
        'ProductCodeWithCheckerDigit': productCodeWithCheckerDigit,
        'InscriptionNumber': inscriptionNumber,
      };

  factory BsEnterpriseModel.fromEntity(BsEnterpriseEntity entity) =>
      BsEnterpriseModel(
        code: entity.Code,
        personalizedCode: entity.PersonalizedCode,
        name: entity.Name,
        cnpjNumber: entity.CnpjNumber,
        codigoInternoVendaMobileModeloPedido:
            entity.CodigoInternoVendaMobile_ModeloPedido,
        useEcommerceSale: entity.useEcommerceSale,
        useRetailSale: entity.useRetailSale,
        useWholeSale: entity.useWholeSale,
        enterpriseParticipateEnterpriseGroup:
            entity.EnterpriseParticipateEnterpriseGroup,
        productCodeSizeOfBalanceLabel: entity.ProductCodeSizeOfBalanceLabel,
        productCodeWithCheckerDigit: entity.ProductCodeWithCheckerDigit,
        inscriptionNumber: entity.InscriptionNumber,
      );

  BsEnterpriseEntity toEntity() => BsEnterpriseEntity(
        Code: code,
        PersonalizedCode: personalizedCode,
        Name: name,
        CnpjNumber: cnpjNumber,
        CodigoInternoVendaMobile_ModeloPedido:
            codigoInternoVendaMobileModeloPedido,
        useEcommerceSale: useEcommerceSale,
        useRetailSale: useRetailSale,
        useWholeSale: useWholeSale,
        EnterpriseParticipateEnterpriseGroup:
            enterpriseParticipateEnterpriseGroup,
        ProductCodeSizeOfBalanceLabel: productCodeSizeOfBalanceLabel,
        ProductCodeWithCheckerDigit: productCodeWithCheckerDigit,
        InscriptionNumber: inscriptionNumber,
      );

  @override
  List<Object?> get props => [
        code,
        personalizedCode,
        name,
        cnpjNumber,
        codigoInternoVendaMobileModeloPedido,
        useEcommerceSale,
        useRetailSale,
        useWholeSale,
        enterpriseParticipateEnterpriseGroup,
        productCodeSizeOfBalanceLabel,
        productCodeWithCheckerDigit,
        inscriptionNumber,
      ];
}

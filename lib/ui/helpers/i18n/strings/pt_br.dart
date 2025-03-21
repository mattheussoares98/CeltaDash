// ignore_for_file: annotate_overrides

import './translation.dart';

class PtBr implements Translation {
  String get msgUnexpectedError => "Ocorreu um erro não esperado";
  String get msgInvalidEmail => "E-mail inválido";
  String get msgInvalidField => "Campo inválido";
  String get msgRequiredField => "Campo obrigatório";
  String get msgVeryShortField => "Campo muito curto";
  String get msgWriteSomething => "Digite algo";

  String get close => "Fechar";
  String get dateNotUpdated => "Data não atualizada";
  String get email => "E-mail";
  String get enter => "Entrar";
  String get indicators => "Indicadores";
  String get no => "Não";
  String get password => "Senha";
  String get products => "Produtos";
  String get profitability => "Rentabilidade";
  String get resume => "Resumo";
  String get sales => "Vendas";
  String get team => "Time";
  String get wait => "Aguarde...";
  String get yes => "Sim";
}

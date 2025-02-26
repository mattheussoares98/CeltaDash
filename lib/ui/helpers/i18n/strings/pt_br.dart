// ignore_for_file: annotate_overrides

import './translation.dart';

class PtBr implements Translation {
  String get msgUnexpectedError => "Ocorreu um erro não esperado";
  String get msgInvalidField => "Campo inválido";
  String get msgRequiredField => "Campo obrigatório";
  String get msgVeryShortField => "Campo muito curto";
  String get msgWriteSomething => "Digite algo";

  String get close => "Fechar";
  String get dateNotUpdated => "Data não atualizada";
  String get no => "Não";
  String get wait => "Aguarde...";
  String get yes => "Sim";
}

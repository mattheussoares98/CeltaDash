import 'package:equatable/equatable.dart';

class EnterpriseViewModel extends Equatable {
  final String? id;
  final String? name;
  final String? personalizedCode;
  final String? cnpj;

  const EnterpriseViewModel({
    this.id,
    this.name,
    this.personalizedCode,
    this.cnpj,
  });

  @override
  List<Object?> get props => [id, name, personalizedCode, cnpj];
}

import 'package:equatable/equatable.dart';

class FirebaseSubEnterpriseViewModel extends Equatable {
  final String? id;
  final String? name;
  final String? personalizedCode;
  final String? cnpj;

  const FirebaseSubEnterpriseViewModel({
    required this.id,
    required this.name,
    required this.personalizedCode,
    required this.cnpj,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        personalizedCode,
        cnpj,
      ];
}

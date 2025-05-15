import 'package:equatable/equatable.dart';
import 'entities.dart';

class FirebaseEnterpriseEntity extends Equatable {
  final String? baseUrl;
  final String? enterpriseName;
  final BsUserEntity? bsUser;
  final List<EnterpriseEntity>?
      subEnterprises; //save in firebase the same enterprise that return in RemoteLoadEnterprises

  const FirebaseEnterpriseEntity({
    required this.baseUrl,
    required this.enterpriseName,
    required this.bsUser,
    required this.subEnterprises,
  });

  @override
  List<Object?> get props => [baseUrl, enterpriseName, bsUser, subEnterprises];
}

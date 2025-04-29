import 'package:equatable/equatable.dart';
import './bs_user_entity.dart';

class FirebaseEnterpriseEntity extends Equatable {
  final String? baseUrl;
  final String? enterpriseName;
  final BsUserEntity? bsUser;

  const FirebaseEnterpriseEntity({
    required this.baseUrl,
    required this.enterpriseName,
    required this.bsUser,
  });

  @override
  List<Object?> get props => [baseUrl, enterpriseName, bsUser];
}

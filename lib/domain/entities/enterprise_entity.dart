import 'package:equatable/equatable.dart';
import './bs_user_entity.dart';

class EnterpriseEntity extends Equatable {
  final String? ccsUrl;
  final String? enterpriseName;
  final BsUserEntity? bsUser;

  const EnterpriseEntity({
    required this.ccsUrl,
    required this.enterpriseName,
    required this.bsUser,
  });

  @override
  List<Object?> get props => [ccsUrl, enterpriseName, bsUser];
}

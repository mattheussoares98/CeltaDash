// lib/core/domain/entities/ec_params.dart
import 'package:celta_dash/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class EcParams extends Equatable {
  final String url;
  final String user;
  final String accessKey;

  const EcParams({
    required this.url,
    required this.user,
    required this.accessKey,
  });

  static EcParams? fromFirebaseEnterprise(
    FirebaseEnterpriseEntity? enterprise,
  ) {
    final url = enterprise?.baseUrl;
    final user = enterprise?.bsUser?.name;
    final accessKey = enterprise?.bsUser?.AccessKey;

    if (url == null || user == null || accessKey == null) {
      return null;
    }

    return EcParams(url: url, user: user, accessKey: accessKey);
  }

  Map<String, String> toHeaders() => {'user': user, 'accessKey': accessKey};

  @override
  List<Object?> get props => [url, user, accessKey];

  EcParams copyWith({String? url, String? user, String? accessKey}) {
    return EcParams(
      url: url ?? this.url,
      user: user ?? this.user,
      accessKey: accessKey ?? this.accessKey,
    );
  }
}

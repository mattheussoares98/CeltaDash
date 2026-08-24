import 'package:equatable/equatable.dart';

class WebAnalyticsUserEntity extends Equatable {
  final String userName;
  final String platform;

  const WebAnalyticsUserEntity({
    required this.userName,
    required this.platform,
  });

  WebAnalyticsUserEntity copyWith({String? userName, String? platform}) =>
      WebAnalyticsUserEntity(
        userName: userName ?? this.userName,
        platform: platform ?? this.platform,
      );

  @override
  List<Object?> get props => [userName, platform];
}

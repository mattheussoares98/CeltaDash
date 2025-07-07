import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../domain/entities/entities.dart';

class ActiveUserViewModel extends Equatable {
  final String userName;
  final String lastActiveFormatted;
  final IconData platformIcon;

  const ActiveUserViewModel({
    required this.userName,
    required this.lastActiveFormatted,
    required this.platformIcon,
  });

  factory ActiveUserViewModel.fromEntity(ActiveUserEntity entity) {
    return ActiveUserViewModel(
      userName: entity.userName,
      lastActiveFormatted: DateFormat.yMd().add_jm().format(entity.lastActive),
      platformIcon: _getPlatformIcon(entity.platform),
    );
  }

  @override
  List<Object?> get props => [userName, lastActiveFormatted, platformIcon];
}

IconData _getPlatformIcon(String platformName) {
  switch (platformName.toLowerCase()) {
    case 'android':
      return Icons.android;
    case 'ios':
      return Icons.apple;
    case 'windows':
      return Icons.desktop_windows;
    case 'linux':
      return Icons.laptop;
    case 'macos':
      return Icons.laptop_mac;
    case 'web':
      return Icons.web;
    default:
      return Icons.device_unknown;
  }
}

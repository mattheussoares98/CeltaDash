import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DefaultTab extends StatelessWidget {
  final String title;
  final IconData materialIcon;
  final IconData cupertinoIcon;

  const DefaultTab({
    super.key,
    required this.title,
    required this.materialIcon,
    required this.cupertinoIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          size: 20,
          !kIsWeb && Platform.isIOS ? cupertinoIcon : materialIcon,
        ),
        Text(title),
      ],
    );
  }
}

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';

class ConnectedEnterprises extends StatelessWidget {
  const ConnectedEnterprises({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            R.string.connectedEnterprises,
            style: Theme.of(context).textTheme.displayLarge,
            textAlign: TextAlign.center,
          ),
        ),
        IconButton(
          icon: Icon(Platform.isIOS ? CupertinoIcons.xmark : Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}

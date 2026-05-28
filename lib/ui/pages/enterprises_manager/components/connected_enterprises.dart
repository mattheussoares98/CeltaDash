import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../helpers/helpers.dart';
import '../../pages.dart';

class ConnectedEnterprises extends StatelessWidget {
  const ConnectedEnterprises({super.key});

  @override
  Widget build(BuildContext context) {
    final enterprisesManagerPresenter = Get.find<EnterprisesManagerPresenter>();
    final isIOS = !kIsWeb && Platform.isIOS;

    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onLongPress: enterprisesManagerPresenter.goToWebLoginPage,
            child: Text(
              R.string.connectedEnterprises,
              style: Theme.of(context).textTheme.displayLarge,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        IconButton(
          icon: Icon(isIOS ? CupertinoIcons.xmark : Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}

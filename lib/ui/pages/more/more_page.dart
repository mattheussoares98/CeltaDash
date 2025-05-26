import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';

class MorePage extends StatelessWidget {
  final MorePresenter presenter;
  const MorePage({
    super.key,
    required this.presenter,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(R.string.more),
        actions: [
          IconButton(
            onPressed: () {
              notificationDialog(
                context: context,
                titleMessage: R.string.msgReallyWantLogout,
                content: null,
                onPress: presenter.doLogout,
              );
            },
            icon: Icon(
              Platform.isIOS
                  ? CupertinoIcons.arrow_right_square
                  : Icons.exit_to_app,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DefaultButton(
              onTap: () {},
              title: R.string.operators,
            ),
          ],
        ),
      ),
    );
  }
}

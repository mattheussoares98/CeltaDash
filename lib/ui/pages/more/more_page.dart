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
      appBar: AppBar(title: Text(R.string.more)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () async {
                notificationDialog(
                  context: context,
                  titleMessage: R.string.msgReallyWantLogout,
                  content: null,
                  onPress: () async {
                    await presenter.doLogout();
                  },
                );
              },
              child: Text(R.string.logout),
            )
          ],
        ),
      ),
    );
  }
}

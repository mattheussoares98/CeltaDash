import 'package:flutter/material.dart';

import '../../../ui/components/components.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';

class ConfigurationsPage extends StatelessWidget {
  final ConfigurationsPresenter configurationsPresenter;
  const ConfigurationsPage({
    super.key,
    required this.configurationsPresenter,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(R.string.configurations),
      ),
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
                    await configurationsPresenter.doLogout();
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

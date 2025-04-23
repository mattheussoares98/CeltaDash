import 'package:flutter/material.dart';

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
              onPressed: () {},
              child: Text(R.string.logout),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../components/components.dart';

class TeamPage extends StatelessWidget {
  const TeamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(onChangeDateOrEnterprise: () {}),
      body: Center(child: Text("Team")),
    );
  }
}

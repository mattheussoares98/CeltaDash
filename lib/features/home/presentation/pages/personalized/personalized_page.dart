import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';

class PersonalizedPage extends StatelessWidget {
  const PersonalizedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      isScrollable: false,
      appBar: BaseAppBar(
        title: 'Personalizado'.hardcoded,
      ),
      body: Center(child: BaseText.titleLarge('Personalizado'.hardcoded)),
    );
  }
}

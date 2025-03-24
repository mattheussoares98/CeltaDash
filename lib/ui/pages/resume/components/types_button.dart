import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../resume.dart';

class TypesButton extends StatelessWidget {
  const TypesButton({super.key});

  @override
  Widget build(BuildContext context) {
    ResumePresenter resumePresenter = Provider.of(context, listen: false);

    return ElevatedButton(
      onPressed: resumePresenter.goToPaymentsTypePage,
      child: Text("" + "Tipos de pagamento"),
    );
  }
}

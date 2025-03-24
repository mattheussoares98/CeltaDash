import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../resume.dart';

class SectionsButton extends StatelessWidget {
  const SectionsButton({super.key});

  @override
  Widget build(BuildContext context) {
    ResumePresenter resumePresenter = Provider.of(context, listen: false);

    return TextButton(
      onPressed: resumePresenter.goToSectionsPage,
      child: Text("" + "Sections"),
    );
  }
}

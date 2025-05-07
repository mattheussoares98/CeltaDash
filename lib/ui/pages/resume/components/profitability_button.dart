import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../../helpers/helpers.dart';
import '../resume.dart';

class ProfitabilityButton extends StatelessWidget {
  const ProfitabilityButton({super.key});

  @override
  Widget build(BuildContext context) {
    ResumePresenter resumePresenter = Get.find();

    return ElevatedButton.icon(
      onPressed: resumePresenter.goToProfitabillityPage,
      label: Text(R.string.profitability),
      icon: Icon(Icons.arrow_outward_sharp, color: Colors.white),
      iconAlignment: IconAlignment.end,
    );
  }
}

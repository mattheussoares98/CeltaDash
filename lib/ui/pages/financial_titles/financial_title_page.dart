import 'package:celta_dash/ui/components/components.dart';
import 'package:celta_dash/ui/helpers/helpers.dart';
import 'package:celta_dash/ui/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FinancialTitlePage extends StatelessWidget {
  const FinancialTitlePage({super.key});

  @override
  Widget build(BuildContext context) {
    FinancialTitlesPresenter resumePresenter = Get.find();

    return Scaffold(
      appBar: DefaultAppBar(
        showEnterpriseManagerButton: true,
        isLoading: false,
        showDatePicker: true,
        onChangeEnterprise: (_) {
          // resumePresenter.load(key: key, params: params); //TODO load
        },
        onChangeDate: (_) {
          // resumePresenter.load(key: key, params: params); //TODO load
        },
      ),
      body: DefaultSafeArea(
        child: Center(
          child: Text(R.string.financial),
        ),
      ),
    );
  }
}

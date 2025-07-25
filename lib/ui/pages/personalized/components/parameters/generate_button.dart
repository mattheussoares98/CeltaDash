import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../helpers/helpers.dart';
import '../../../pages.dart';

class GenerateButton extends StatelessWidget {
  final void Function(bool collapseParameters) collapseAll;
  const GenerateButton({super.key, required this.collapseAll});

  @override
  Widget build(BuildContext context) {
    final personalizedPresenter = Get.find<PersonalizedPresenter>();

    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ElevatedButton(
              onPressed: () async {
                final succeeds = await personalizedPresenter.getSales();
                if (succeeds) {
                  collapseAll(true);
                }
              },
              child: Text(R.string.generate),
            ),
          ),
        ),
      ],
    );
  }
}

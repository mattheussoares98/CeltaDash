import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../helpers/helpers.dart';
import '../../../pages.dart';

class GenerateButton extends StatelessWidget {
  final void Function(bool collapseParameters) collapseAll;
  final bool? isLoading;
  const GenerateButton({
    super.key,
    required this.collapseAll,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final personalizedPresenter = Get.find<PersonalizedPresenter>();

    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ElevatedButton(
              onPressed: isLoading == true
                  ? null
                  : () async {
                      final succeeds = await personalizedPresenter.getSales();
                      if (succeeds) {
                        collapseAll(true);
                      }
                    },
              child: isLoading == true
                  ? const SizedBox(
                      height: 15,
                      width: 15,
                      child: CircularProgressIndicator(
                        strokeWidth: 0.5,
                      ),
                    )
                  : Text(R.string.generate),
            ),
          ),
        ),
      ],
    );
  }
}

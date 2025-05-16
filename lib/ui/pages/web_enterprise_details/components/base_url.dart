import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../helpers/helpers.dart';
import '../../pages.dart';

class BaseUrl extends StatelessWidget {
  final void Function() updateShowChangeBaseUrl;
  final bool showChangeBaseUrl;
  const BaseUrl({
    super.key,
    required this.updateShowChangeBaseUrl,
    required this.showChangeBaseUrl,
  });

  @override
  Widget build(BuildContext context) {
    WebEnterprisesPresenter webEnterprisesPresenter = Get.find();

    return Row(
      children: [
        Expanded(
            child: Text(
                "${R.string.url}: ${webEnterprisesPresenter.selectedEnterprise?.baseUrl}")),
        IconButton(
          icon: Icon(
            showChangeBaseUrl ? Icons.cancel : Icons.edit,
          ),
          onPressed: updateShowChangeBaseUrl,
        ),
      ],
    );
  }
}

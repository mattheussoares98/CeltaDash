import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../helpers/helpers.dart';
import '../../pages.dart';

class SubEnterprises extends StatelessWidget {
  const SubEnterprises({super.key});

  @override
  Widget build(BuildContext context) {
    WebEnterprisesPresenter webEnterprisesPresenter = Get.find();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            (webEnterprisesPresenter.selectedEnterprise?.firebaseSubEnterprises
                            ?.length ??
                        0) >
                    0
                ? R.string.subEnterprises
                : R.string.emptySubEnterprises,
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: webEnterprisesPresenter
                  .selectedEnterprise?.firebaseSubEnterprises?.length ??
              0,
          itemBuilder: (context, index) {
            final subEnterprise = webEnterprisesPresenter
                .selectedEnterprise?.firebaseSubEnterprises?[index];

            return Container(
              decoration: ContainerDecoration.decoration,
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.symmetric(vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${subEnterprise?.personalizedCode} - ${subEnterprise?.name}",
                  ),
                  Text("${R.string.cnpj}: ${subEnterprise?.cnpj}"),
                  Row(
                    children: [
                      Expanded(child: Text("${R.string.enabled}: ")),
                      Switch(
                        value: subEnterprise?.enabled == "true",
                        onChanged: (value) {
                          debugPrint(value.toString());
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        )
      ],
    );
  }
}

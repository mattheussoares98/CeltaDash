import 'dart:io';

import 'package:celta_dash/ui/helpers/helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../main/builders/builders.dart';
import '../../pages.dart';

class EnterprisesItems extends StatelessWidget {
  final ScrollController scrollController;

  const EnterprisesItems({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final enterprisesManagerPresenter = Get.find<EnterprisesManagerPresenter>();
    final theme = Theme.of(context);

    return Obx(() {
      enterprisesManagerPresenter.allEnterprises
          ?.sort((a, b) => a.enterpriseName!.compareTo(b.enterpriseName!));
      return ListView.builder(
        controller: scrollController,
        itemCount: enterprisesManagerPresenter.allEnterprises?.length ?? 0,
        itemBuilder: (context, index) {
          final enterprise = enterprisesManagerPresenter.allEnterprises![index];
          final isSelected =
              EnterpriseBuilder.entity?.firebaseId == enterprise.firebaseId;

          return Container(
            margin: EdgeInsets.only(bottom: 8),
            decoration: isSelected
                ? ContainerDecoration.enabled
                : ContainerDecoration.disabled,
            child: ListTile(
              title: Text(
                enterprise.enterpriseName?.toUpperCase() ?? "null",
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              trailing: isSelected
                  ? Icon(
                      Platform.isIOS
                          ? CupertinoIcons.checkmark
                          : Icons.check_circle,
                      color: theme.colorScheme.primary)
                  : null,
              onTap: () => enterprisesManagerPresenter
                  .updateSelectedEnterprise(enterprise),
            ),
          );
        },
      );
    });
  }
}

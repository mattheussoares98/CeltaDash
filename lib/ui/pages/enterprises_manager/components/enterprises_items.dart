import 'dart:io';

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

    return ListView.builder(
      controller: scrollController,
      itemCount: enterprisesManagerPresenter.allEnterprises?.length ?? 0,
      itemBuilder: (context, index) {
        final enterprise = enterprisesManagerPresenter.allEnterprises![index];
        final isSelected =
            EnterpriseBuilder.entity?.firebaseId == enterprise.firebaseId;

        return Card(
          elevation: isSelected ? 4.0 : 1.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: isSelected
                ? BorderSide(color: theme.colorScheme.primary, width: 2)
                : BorderSide.none,
          ),
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
  }
}

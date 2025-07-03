import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../main/builders/builders.dart';
import '../../../../ui/components/components.dart';
import '../../../../ui/helpers/helpers.dart';
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

          return Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(bottom: 8),
                  decoration: isSelected
                      ? ContainerDecoration.enabled
                      : ContainerDecoration.defaultDecoration,
                  child: ListTile(
                    title: Text(
                      enterprise.enterpriseName?.toUpperCase() ?? "null",
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected
                            ? theme.primaryColor
                            : Colors.black,
                      ),
                    ),
                    trailing: isSelected
                        ? Icon(
                            Platform.isIOS
                                ? CupertinoIcons.checkmark
                                : Icons.check_circle,
                            color: theme.colorScheme.primary)
                        : null,
                    onTap: () {
                      enterprisesManagerPresenter
                          .updateSelectedEnterprise(enterprise);
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: IconButton(
                  onPressed: isSelected
                      ? null
                      : () {
                          notificationDialog(
                            context: context,
                            titleMessage: "${R.string.removeEnterprise}?",
                            content: null,
                            onPress: () async {
                              await enterprisesManagerPresenter
                                  .removeEnterprise(enterprise.enterpriseName);
                            },
                          );
                        },
                  icon: Icon(
                    Platform.isIOS ? CupertinoIcons.trash : Icons.delete,
                    color: isSelected
                        ? theme.disabledColor
                        : theme.colorScheme.error,
                  ),
                ),
              )
            ],
          );
        },
      );
    });
  }
}

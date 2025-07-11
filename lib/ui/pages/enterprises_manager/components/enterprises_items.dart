import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../main/builders/builders.dart';
import '../../../../ui/components/components.dart';
import '../../../../ui/helpers/helpers.dart';
import '../../pages.dart';

class EnterprisesItems extends StatefulWidget {
  final ScrollController scrollController;

  const EnterprisesItems({super.key, required this.scrollController});

  @override
  State<EnterprisesItems> createState() => _EnterprisesItemsState();
}

class _EnterprisesItemsState extends State<EnterprisesItems> {
  @override
  Widget build(BuildContext context) {
    final enterprisesManagerPresenter = Get.find<EnterprisesManagerPresenter>();
    final theme = Theme.of(context);

    return Obx(() {
      final selectedId = EnterpriseBuilder.entity?.firebaseId;

      enterprisesManagerPresenter.allEnterprises?.sort((a, b) {
        final isASelected = a.firebaseId == selectedId;
        final isBSelected = b.firebaseId == selectedId;

        if (isASelected) return -1; // 'a' is selected, it comes first
        if (isBSelected) return 1; // 'b' is selected, it comes first

        // Otherwise, sort alphabetically
        return a.enterpriseName!.compareTo(b.enterpriseName!);
      });

      return ListView.builder(
        controller: widget.scrollController,
        shrinkWrap: true,
        itemCount: enterprisesManagerPresenter.allEnterprises?.length ?? 0,
        itemBuilder: (context, index) {
          final enterprise = enterprisesManagerPresenter.allEnterprises![index];
          final isSelected =
              EnterpriseBuilder.entity?.firebaseId == enterprise.firebaseId;

          return Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: isSelected
                      ? ContainerDecoration.enabled
                      : ContainerDecoration.defaultDecoration,
                  child: ListTile(
                    title: Text(
                      enterprise.enterpriseName?.toUpperCase() ?? "null",
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? theme.primaryColor : Colors.black,
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
              isSelected
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: IconButton(
                        onPressed: () {
                          notificationDialog(
                            context: context,
                            titleMessage: "${R.string.removeEnterprise}?",
                            content: null,
                            onPress: () async {
                              await enterprisesManagerPresenter
                                  .removeEnterprise(enterprise.enterpriseName);
                              setState(() {});
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

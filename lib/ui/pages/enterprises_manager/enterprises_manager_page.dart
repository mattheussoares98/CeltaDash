import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../main/builders/builders.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';

class EnterprisesManagerPage extends StatefulWidget {
  const EnterprisesManagerPage({super.key});

  @override
  State<EnterprisesManagerPage> createState() => _EnterprisesManagerPageState();
  static void showEnterpriseSelection(
    BuildContext context,
    EnterprisesManagerPresenter enterprisesManagerPresenter,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows the modal to be full-screen
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      useSafeArea: true,
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
                child: GestureDetector(
              onTap: Navigator.of(context).pop,
            )),
            DraggableScrollableSheet(
              initialChildSize: 0.95,
              minChildSize: 0.5,
              maxChildSize: 0.95,
              builder: (_, controller) {
                return EnterprisesManagerPage();
              },
            ),
          ],
        );
      },
    );
  }
}

class _EnterprisesManagerPageState extends State<EnterprisesManagerPage> {
  final scrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final enterprisesManagerPresenter = Get.find<EnterprisesManagerPresenter>();

    final theme = Theme.of(context);
    return Obx(() {
      return Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    R.string.connectedEnterprises,
                    style: Theme.of(context).textTheme.displayLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
                IconButton(
                  icon:
                      Icon(Platform.isIOS ? CupertinoIcons.xmark : Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Implement navigation to your "Add New Enterprise" page
                print('Navigate to Add New Company Page');
              },
              icon: Icon(Platform.isIOS
                  ? CupertinoIcons.add_circled
                  : Icons.add_circle_outline),
              label: Text(R.string.addNewEnterprise),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount:
                    enterprisesManagerPresenter.allEnterprises?.length ?? 0,
                itemBuilder: (context, index) {
                  final enterprise =
                      enterprisesManagerPresenter.allEnterprises![index];
                  final isSelected = EnterpriseBuilder.entity?.firebaseId ==
                      enterprise.firebaseId;

                  return Card(
                    elevation: isSelected ? 4.0 : 1.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: isSelected
                          ? BorderSide(
                              color: theme.colorScheme.primary, width: 2)
                          : BorderSide.none,
                    ),
                    child: ListTile(
                      title: Text(
                        enterprise.enterpriseName?.toUpperCase() ?? "null",
                        style: TextStyle(
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
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
              ),
            ),
          ],
        ),
      );
    });
  }
}

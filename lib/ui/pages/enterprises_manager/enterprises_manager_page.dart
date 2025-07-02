import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../main/builders/builders.dart';
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
        return DraggableScrollableSheet(
          initialChildSize: 0.95, // Set the initial height to 90% of the screen
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (_, controller) {
            return EnterprisesManagerPage();
          },
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
        // This creates the rounded top corners for the modal sheet
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // --- Custom AppBar for the Modal ---
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Manage Connections',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            // --- Add New Company Button ---
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Implement navigation to your "Add New Enterprise" page
                  print('Navigate to Add New Company Page');
                },
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('Add New Company'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const Divider(indent: 16, endIndent: 16),
            // --- List of Available Companies ---

            Expanded(
              child: ListView.builder(
                controller: scrollController, // Connect the scroll controller
                itemCount:
                    enterprisesManagerPresenter.allEnterprises?.length ?? 0,
                itemBuilder: (context, index) {
                  final enterprise =
                      enterprisesManagerPresenter.allEnterprises![index];
                  final isSelected = EnterpriseBuilder.entity?.firebaseId ==
                      enterprise.firebaseId;

                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
                        enterprise.enterpriseName ?? "null",
                        style: TextStyle(
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      trailing: isSelected
                          ? Icon(Icons.check_circle,
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

class EnterpriseSelectionPage extends StatelessWidget {
  final Function(FirebaseEnterpriseViewModel) onCompanySelected;
  final ScrollController scrollController;

  const EnterpriseSelectionPage({
    super.key,
    required this.onCompanySelected,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final enterprisesManagerPresenter = Get.find<EnterprisesManagerPresenter>();

    final theme = Theme.of(context);
    return Container(
      // This creates the rounded top corners for the modal sheet
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // --- Custom AppBar for the Modal ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Manage Connections',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          // --- Add New Company Button ---
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: Implement navigation to your "Add New Enterprise" page
                print('Navigate to Add New Company Page');
              },
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('Add New Company'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const Divider(indent: 16, endIndent: 16),
          // --- List of Available Companies ---
          Expanded(
            child: ListView.builder(
              controller: scrollController, // Connect the scroll controller
              itemCount:
                  enterprisesManagerPresenter.allEnterprises?.length ?? 0,
              itemBuilder: (context, index) {
                final enterprise =
                    enterprisesManagerPresenter.allEnterprises![index];
                final isSelected = EnterpriseBuilder.entity?.firebaseId ==
                    enterprise.firebaseId;

                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  elevation: isSelected ? 4.0 : 1.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: isSelected
                        ? BorderSide(color: theme.colorScheme.primary, width: 2)
                        : BorderSide.none,
                  ),
                  child: ListTile(
                    title: Text(
                      enterprise.enterpriseName ?? "",
                      style: TextStyle(
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    trailing: isSelected
                        ? Icon(Icons.check_circle,
                            color: theme.colorScheme.primary)
                        : null,
                    onTap: () => onCompanySelected(enterprise),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

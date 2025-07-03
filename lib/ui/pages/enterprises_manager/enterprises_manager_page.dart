import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../mixins/mixins.dart';
import '../pages.dart';
import 'components/components.dart';

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

class _EnterprisesManagerPageState extends State<EnterprisesManagerPage>
    with UIErrorManager, LoadingManager {
  final scrollController = ScrollController();

  final enterpriseNameController = TextEditingController();
  final bsUserNameController = TextEditingController();
  final bsPasswordController = TextEditingController();

  final enterpriseNameFocusNode = FocusNode();
  final bsUserNameFocusNode = FocusNode();
  final bsPasswordFocusNode = FocusNode();

  StreamSubscription? mainErrorSubscription;
  StreamSubscription? loadingSubscription;

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    enterpriseNameController.dispose();
    bsUserNameController.dispose();
    bsPasswordController.dispose();

    enterpriseNameFocusNode.dispose();
    bsUserNameFocusNode.dispose();
    bsPasswordFocusNode.dispose();

    mainErrorSubscription?.cancel();
    loadingSubscription?.cancel();
  }

  @override
  void initState() {
    super.initState();

    final enterprisesManagerPresenter = Get.find<EnterprisesManagerPresenter>();

    mainErrorSubscription = handleMainError(
      context,
      enterprisesManagerPresenter.mainErrorStream,
    );

    loadingSubscription = handleLoading(
      context,
      enterprisesManagerPresenter.isLoadingStream,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            ConnectedEnterprises(),
            AddNewEnterprise(
              enterpriseNameController: enterpriseNameController,
              bsUserNameController: bsUserNameController,
              bsPasswordController: bsPasswordController,
              enterpriseNameFocusNode: enterpriseNameFocusNode,
              bsUserNameFocusNode: bsUserNameFocusNode,
              bsPasswordFocusNode: bsPasswordFocusNode,
            ),
            const Divider(),
            Expanded(
              child: EnterprisesItems(scrollController: scrollController),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/web_enterprises/presentation/controllers/controllers.dart';
import 'package:celta_dash/features/web_enterprises/presentation/pages/components/components.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WebEnterprisesPage extends HookConsumerWidget {
  const WebEnterprisesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = useState(0);

    return BaseScaffold(
      isScrollable: false,
      padding: const .symmetric(horizontal: Sizes.p8),
      appBar: BaseAppBar(
        title: 'Clientes'.hardcoded,
        actions: selectedIndex.value == 0
            ? [
                BaseIconButton(
                  onPressed: () =>
                      showModalPage(const CreateEnterpriseForm(), context),
                  platformIcon: const PlatformIcon(
                    materialIcon: Icons.add_business,
                    cupertinoIcon: CupertinoIcons.add_circled_solid,
                  ),
                ),
              ]
            : null,
      ),
      onRefresh: ref.read(remoteEnterprisesControllerProvider.notifier).refresh,
      body: IndexedStack(
        index: selectedIndex.value,
        children: const [RemoteEnterprisesView(), WebAnalyticsView()],
      ),
      bottomNavigationBar: BaseBottomNavigationBar(
        currentIndex: selectedIndex.value,
        onTap: (index) => selectedIndex.value = index,
        items: [
          BaseBottomNavigationBarItem(
            platformIcon: const PlatformIcon(
              materialIcon: Icons.business,
              cupertinoIcon: CupertinoIcons.briefcase,
            ),
            label: 'Empresas'.hardcoded,
          ),
          BaseBottomNavigationBarItem(
            platformIcon: const PlatformIcon(
              materialIcon: Icons.auto_graph,
              cupertinoIcon: CupertinoIcons.graph_circle,
            ),
            label: 'Análises'.hardcoded,
          ),
        ],
      ),
    );
  }
}

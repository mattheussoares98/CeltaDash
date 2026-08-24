import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/web_enterprises/presentation/controllers/controllers.dart';
import 'package:celta_dash/features/web_enterprises/presentation/pages/components/components.dart';
import 'package:celta_dash/utils/utils.dart';
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
      appBar: BaseAppBar(title: 'Clientes'.hardcoded),
      onRefresh: ref.read(remoteEnterprisesControllerProvider.notifier).refresh,
      body: IndexedStack(
        index: selectedIndex.value,
        children: const [RemoteEnterprisesView(), WebAnalyticsView()],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex.value,
        onDestinationSelected: (index) => selectedIndex.value = index,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.business),
            label: 'Empresas'.hardcoded,
          ),
          NavigationDestination(
            icon: const Icon(Icons.auto_graph),
            label: 'Análises'.hardcoded,
          ),
        ],
      ),
    );
  }
}

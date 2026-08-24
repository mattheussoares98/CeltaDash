import 'package:celta_dash/commom_widgets/commom_widgets.dart';
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
    final selectedPeriod = useState(
      DateTime(DateTime.now().year, DateTime.now().month),
    );

    return BaseScaffold(
      isScrollable: false,
      appBar: BaseAppBar(title: 'Empresas remotas'.hardcoded),
      body: IndexedStack(
        index: selectedIndex.value,
        children: [
          const RemoteEnterprisesView(),
          WebAnalyticsView(
            selectedPeriod: selectedPeriod.value,
            onPeriodChanged: (period) => selectedPeriod.value = period,
          ),
        ],
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

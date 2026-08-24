import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/web_enterprises/presentation/controllers/controllers.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RemoteEnterprisesView extends ConsumerWidget {
  const RemoteEnterprisesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enterprises = ref.watch(remoteEnterprisesControllerProvider);

    return AsyncValueWidget(
      value: enterprises,
      preserveValue: true,
      tryAgain: () => ref.invalidate(remoteEnterprisesControllerProvider),
      data: (items) {
        if (items.isEmpty) {
          return Center(child: Text('Nenhuma empresa encontrada'.hardcoded));
        }

        return RefreshIndicator.adaptive(
          onRefresh: () =>
              ref.read(remoteEnterprisesControllerProvider.notifier).refresh(),
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (_, _) => gapH8,
            itemBuilder: (context, index) {
              final enterprise = items[index];
              return Card(
                child: ListTile(
                  leading: const PlatformIcon(
                    materialIcon: Icons.business,
                    cupertinoIcon: Icons.business,
                  ),
                  title: Text(
                    enterprise.enterpriseName ??
                        'Empresa sem identificação'.hardcoded,
                  ),
                  subtitle: enterprise.baseUrl == null
                      ? null
                      : Text(enterprise.baseUrl!),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

import 'package:celta_dash/features/enterprises_manager/presentation/pages/components/components.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';

class EnterprisesManagerContent extends StatelessWidget {
  const EnterprisesManagerContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: AddEnterpriseForm()),
        gapSliverH16,
        SliverToBoxAdapter(child: Divider()),
        gapSliverH16,
        SavedEnterprisesList(),
        gapSliverH32,
      ],
    );
  }
}

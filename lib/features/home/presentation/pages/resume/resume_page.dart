import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/home/presentation/pages/resume/components/components.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ResumePage extends ConsumerWidget {
  const ResumePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      const BaseScaffold(usePadding: false, body: DailyComparisonCard());
}

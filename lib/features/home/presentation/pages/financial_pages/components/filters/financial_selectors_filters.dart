import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/financial_titles/domain/entities/entities.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part './financial_period_type_selector.dart';
part './financial_situation_selector.dart';

class FinancialSelectorsFilters extends StatelessWidget {
  const FinancialSelectorsFilters({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _FinancialSituationSelector(),
        gapW8,
        _FinancialPeriodTypeSelector(),
      ],
    );
  }
}

import 'package:celta_dash/domain/entities/entities.dart';
import 'package:celta_dash/ui/components/components.dart';
import 'package:celta_dash/ui/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FinancialTitlePage extends StatefulWidget {
  const FinancialTitlePage({super.key});

  @override
  State<FinancialTitlePage> createState() => _FinancialTitlePageState();
}

class _FinancialTitlePageState extends State<FinancialTitlePage> {
  @override
  void initState() {
    super.initState();

    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _load());
    }
  }

  SearchFinancialTitleDataParams? _params(HomePresenter homePresenter) {
    final enterpriseId =
        int.tryParse(homePresenter.selectedEnterprise?.id ?? '');
    if (enterpriseId == null) return null;

    final selectedDate = homePresenter.selectedDate;
    return SearchFinancialTitleDataParams(
      enterpriseCodes: [enterpriseId],
      financialTitleTypes: FinancialTitleType.values,
      situations: FinancialTitleSituation.values,
      periodType: FinancialTitlePeriodType.expiration,
      period: FinancialTitlePeriodParams(
        startDate: DateTime(selectedDate.year, selectedDate.month),
        endDate: DateTime(selectedDate.year, selectedDate.month + 1, 0),
      ),
      periodGrouping: FinancialTitlePeriodGrouping.day,
    );
  }

  Future<void> _load({bool forceRefresh = false}) async {
    final homePresenter = Get.find<HomePresenter>();
    final params = _params(homePresenter);
    if (params == null) return;

    await Get.find<FinancialTitlesPresenter>().load(
      key: FinancialTitlePageRequest.daily,
      params: params,
      forceRefresh: forceRefresh,
    );
  }

  @override
  Widget build(BuildContext context) {
    final homePresenter = Get.find<HomePresenter>();
    final presenter = Get.find<FinancialTitlesPresenter>();
    final state = presenter.stateOf(FinancialTitlePageRequest.daily);

    return StreamBuilder<FinancialTitleState>(
      initialData: state,
      stream: presenter.streamOf(FinancialTitlePageRequest.daily),
      builder: (context, snapshot) {
        final currentState = snapshot.data ?? state;
        final rows = currentState.data?.financialTitlePortions ?? const [];

        return Scaffold(
          appBar: DefaultAppBar(
            showEnterpriseManagerButton: true,
            isLoading: currentState.status == FinancialTitleStatus.loading,
            showDatePicker: homePresenter.selectedEnterpriseIsEnabled,
            onChangeEnterprise: (_) => _load(forceRefresh: true),
            onChangeDate: (_) => _load(forceRefresh: true),
          ),
          body: DefaultSafeArea(
            child: RefreshIndicator(
              onRefresh: () => _load(forceRefresh: true),
              child: FinancialTitleDailySummary(
                  rows: rows, reload: () => _load(forceRefresh: true)),
            ),
          ),
        );
      },
    );
  }
}

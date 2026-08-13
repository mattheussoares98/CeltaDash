import 'dart:async';
import 'dart:io';

import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../helpers/helpers.dart';
import '../../mixins/mixins.dart';
import '../pages.dart';

class AppAnalyticsPage extends StatefulWidget {
  const AppAnalyticsPage({super.key});

  @override
  State<AppAnalyticsPage> createState() => _AppAnalyticsPageState();
}

class _AppAnalyticsPageState extends State<AppAnalyticsPage>
    with LoadingManager, UIErrorManager {
  StreamSubscription? mainErrorSubscription;
  StreamSubscription? loadingSubscription;
  static final now = DateTime.now();
  final filteredEnterpriseController = TextEditingController();
  final filteredEnterpriseFocusNode = FocusNode();

  final currentMonth = DateTime(now.year, now.month);
  final previousMonth = DateTime(now.year, now.month - 1);
  final antiPreviousMonth = DateTime(now.year, now.month - 2);

  static final formatter = DateFormat('yyyy/MM');

  final currentMonthFormatted = formatter.format(now);
  final previousMonthFormatted = formatter.format(
    DateTime(now.year, now.month - 1),
  );
  final antiPreviousMonthFormatted = formatter.format(
    DateTime(now.year, now.month - 2),
  );

  @override
  void initState() {
    super.initState();

    final presenter = Get.find<AppAnalyticsPresenter>();

    mainErrorSubscription = handleMainError(context, presenter.mainErrorStream);
    loadingSubscription = handleLoading(context, presenter.isLoadingStream);
  }

  @override
  void dispose() {
    super.dispose();
    mainErrorSubscription?.cancel();
    loadingSubscription?.cancel();
    filteredEnterpriseController.dispose();
    filteredEnterpriseFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appAnalyticsPresenter = Get.find<AppAnalyticsPresenter>();
    final isIOS = !kIsWeb && Platform.isIOS;

    return Scaffold(
      appBar: AppBar(
        title: Text("${R.string.analytics} ${formatter.format(now)}"),
        actions: [
          IconButton(
            onPressed: appAnalyticsPresenter.loadAnalytics,
            icon: Icon(isIOS ? CupertinoIcons.refresh : Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CupertinoSlidingSegmentedControl<DateTime>(
              groupValue: appAnalyticsPresenter.selectedPeriod,
              thumbColor: Theme.of(context).primaryColor,
              onValueChanged: (value) {
                if (value != null) {
                  setState(() {
                    appAnalyticsPresenter.changeSelectedPeriod(value);
                  });
                }
              },
              children: {
                antiPreviousMonth: _Item(
                  period: antiPreviousMonth,
                  periodFormatted: antiPreviousMonthFormatted,
                ),
                previousMonth: _Item(
                  period: previousMonth,
                  periodFormatted: previousMonthFormatted,
                ),
                currentMonth: _Item(
                  period: currentMonth,
                  periodFormatted: currentMonthFormatted,
                ),
              },
            ),
          ),
          FilterEnterpriseFormfield(
            filteredEnterpriseController: filteredEnterpriseController,
            filteredEnterpriseFocusNode: filteredEnterpriseFocusNode,
            callSetState: () => setState(() {}),
          ),
          Expanded(
            child: Obx(() {
              final analytics = appAnalyticsPresenter.analytics
                  ?.where(
                    (e) => e.enterprise.toLowerCase().contains(
                      filteredEnterpriseController.text.toLowerCase(),
                    ),
                  )
                  .toList();
              if (analytics == null || analytics.isEmpty) {
                return Center(child: Text(R.string.empty));
              }

              analytics.sort(
                (a, b) => b.totalSearchesFormatted.toInt()!.compareTo(
                  a.totalSearchesFormatted.toInt()!,
                ),
              );

              return RefreshIndicator(
                onRefresh: appAnalyticsPresenter.loadAnalytics,
                child: ListView.builder(
                  itemCount: analytics.length,
                  itemBuilder: (context, index) {
                    final analytic = analytics[index];
                    return Card(
                      margin: const EdgeInsets.fromLTRB(4, 0, 4, 8),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              analytic.enterprise.toUpperCase(),
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            SearchCounts(analytic: analytic),
                            const Divider(),
                            UsersAndPlatform(analytic: analytic),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final String periodFormatted;
  final DateTime? period;
  const _Item({required this.periodFormatted, required this.period});

  @override
  Widget build(BuildContext context) {
    final selectedPeriod = Get.find<AppAnalyticsPresenter>().selectedPeriod;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        periodFormatted,
        style: TextStyle(color: period == selectedPeriod ? Colors.white : null),
      ),
    );
  }
}

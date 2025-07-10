import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
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
  static final formatter = DateFormat('yyyy/MM');
  final currentMonth = formatter.format(now);
  final previousMonth = formatter.format(DateTime(now.year, now.month - 1));
  final antiPreviousMonth = formatter.format(DateTime(now.year, now.month - 2));
  String? selectedPeriod;

  @override
  void initState() {
    super.initState();

    final presenter = Get.find<AppAnalyticsPresenter>();

    mainErrorSubscription = handleMainError(context, presenter.mainErrorStream);
    loadingSubscription = handleLoading(context, presenter.isLoadingStream);

    selectedPeriod = currentMonth;
  }

  @override
  void dispose() {
    super.dispose();
    mainErrorSubscription?.cancel();
    loadingSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final presenter = Get.find<AppAnalyticsPresenter>();

    return Scaffold(
      appBar: AppBar(
        title: Text("${R.string.analytics} ${formatter.format(now)}"),
        actions: [
          IconButton(
            onPressed: presenter.loadAnalytics,
            icon: Icon(Platform.isIOS ? CupertinoIcons.refresh : Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CupertinoSlidingSegmentedControl<String>(
              groupValue: selectedPeriod,
              thumbColor: Theme.of(context).primaryColor,
              children: {
                antiPreviousMonth: _Item(
                  selectedPeriod: selectedPeriod,
                  value: antiPreviousMonth,
                ),
                previousMonth: _Item(
                  selectedPeriod: selectedPeriod,
                  value: previousMonth,
                ),
                currentMonth: _Item(
                  selectedPeriod: selectedPeriod,
                  value: currentMonth,
                ),
              },
              onValueChanged: (newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedPeriod = newValue;
                  });
                }
              },
            ),
          ),
          Expanded(
            child: Obx(() {
              final analytics = presenter.analytics;
              if (analytics == null || analytics.isEmpty) {
                return Center(
                  child: Text(R.string.empty),
                );
              }

              analytics.sort((a, b) => b.totalSearchesFormatted
                  .toInt()
                  .compareTo(a.totalSearchesFormatted.toInt()));

              return RefreshIndicator(
                onRefresh: presenter.loadAnalytics,
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
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
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
  final String value;
  final String? selectedPeriod;
  const _Item({required this.value, required this.selectedPeriod});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        value,
        style: TextStyle(
          color: selectedPeriod == value ? Colors.white : null,
        ),
      ),
    );
  }
}

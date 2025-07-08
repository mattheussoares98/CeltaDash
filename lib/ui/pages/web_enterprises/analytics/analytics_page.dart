import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../helpers/helpers.dart';
import '../../../mixins/mixins.dart';
import '../../pages.dart';
import 'components/components.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage>
    with LoadingManager, UIErrorManager {
  StreamSubscription? mainErrorSubscription;
  StreamSubscription? loadingSubscription;
  @override
  void initState() {
    super.initState();

    final presenter = Get.find<AnalyticsPresenter>();

    mainErrorSubscription = handleMainError(context, presenter.mainErrorStream);
    loadingSubscription = handleLoading(context, presenter.isLoadingStream);
  }

  @override
  void dispose() {
    super.dispose();
    mainErrorSubscription?.cancel();
    loadingSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final presenter = Get.find<AnalyticsPresenter>();

    return Scaffold(
      appBar: AppBar(
        title: Text(R.string.analytics),
        actions: [
          IconButton(
            onPressed: presenter.loadAnalytics,
            icon: Icon(Platform.isIOS ? CupertinoIcons.refresh : Icons.refresh),
          ),
        ],
      ),
      body: Obx(() {
        final analytics = presenter.analytics;
        if (analytics == null || analytics.isEmpty) {
          return Center(
            child: Text(R.string.empty),
          );
        }

        analytics.sort((a, b) => a.totalSearchesFormatted
            .toInt()
            .compareTo(b.totalSearchesFormatted.toInt()));

        return RefreshIndicator(
          onRefresh: presenter.loadAnalytics,
          child: ListView.builder(
            itemCount: analytics.length,
            itemBuilder: (context, index) {
              final analytic = analytics[index];
              return Card(
                margin: EdgeInsets.fromLTRB(4, 0, 4, 8),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        analytic.enterprise.toUpperCase(),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      SearchCounts(analytic: analytic),
                      Divider(),
                      UsersAndPlatform(analytic: analytic),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}

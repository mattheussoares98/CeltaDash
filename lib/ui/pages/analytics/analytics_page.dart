import 'package:flutter/material.dart';

import '../pages.dart';

class AnalyticsPage extends StatefulWidget {
  final AnalyticsPresenter presenter;
  const AnalyticsPage({super.key, required this.presenter});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  @override
  void initState() {
    super.initState();
    widget.presenter.loadAnalytics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Web Analytics")),
    );
  }
}

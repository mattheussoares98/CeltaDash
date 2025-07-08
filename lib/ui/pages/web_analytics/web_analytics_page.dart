import 'package:flutter/material.dart';

import '../pages.dart';

class WebAnalyticsPage extends StatefulWidget {
  final WebAnalyticsPresenter presenter;
  const WebAnalyticsPage({super.key, required this.presenter});

  @override
  State<WebAnalyticsPage> createState() => _WebAnalyticsPageState();
}

class _WebAnalyticsPageState extends State<WebAnalyticsPage> {
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

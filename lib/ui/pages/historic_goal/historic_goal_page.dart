// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../pages.dart';

class HistoricGoalPage extends StatefulWidget {
  final HistoricGoalPresenter presenter;
  const HistoricGoalPage({
    super.key,
    required this.presenter,
  });

  @override
  State<HistoricGoalPage> createState() => _HistoricGoalPageState();
}

class _HistoricGoalPageState extends State<HistoricGoalPage> {
  @override
  void initState() {
    super.initState();
    widget.presenter.loadHistoricSales(DateTime.now().year);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Goal History")),
      body: Obx(() {
        final sales = widget.presenter.saleStatistics;

        if (sales == null || sales.isEmpty) {
          return const Center(child: Text("No goal history available"));
        }

        return ListView.builder(
          itemCount: sales.length,
          itemBuilder: (context, index) {
            final sale = sales[index];
            return const ListTile(
              title: Text(""),
              subtitle: Text("Goal: "),
            );
          },
        );
      }),
    );
  }
}

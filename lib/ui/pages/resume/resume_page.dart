import 'package:flutter/material.dart';

import 'components/components.dart';

class ResumePage extends StatefulWidget {
  const ResumePage({super.key});

  @override
  State<ResumePage> createState() => _ResumePageState();
}

class _ResumePageState extends State<ResumePage> {
  final scrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: scrollController,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SalesInformations(
                scrollController: scrollController,
                title: "Sales of the day" + "",
                totalSales: 10,
                leftButton: TypesButton(),
                rightButton: SectionsButton(),
                goal: 20,
                children: [
                  Text("" + "Sales quantity\n2000"),
                  Text("" + "Ticket avarage (R\$)\nR\$75,82"),
                  Text("" + "Average price (R\$)\nR\$15"),
                  Text("" + "Products by sale\n9,16"),
                ],
              ),
              const SizedBox(height: 8),
              SalesInformations(
                scrollController: scrollController,
                goal: 1000000,
                title: "Sales of the month" + "",
                totalSales: 800000,
                leftButton: SetGoalButton(),
                rightButton: SectionsButton(),
                children: [Text("" + "Sales until now\nR\$ 165.059,04")],
              ),
              const SizedBox(height: 8),
              ProfitabilityButton(),
              const SizedBox(height: 8),
              DailyAnalysis(),
              SizedBox(height: 15),
              MonthlyAnalysis(),
            ],
          ),
        ),
      ),
    );
  }
}

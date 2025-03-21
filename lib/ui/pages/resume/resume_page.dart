import 'package:flutter/material.dart';

import 'components/components.dart';

class ResumePage extends StatelessWidget {
  const ResumePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
          child: Column(
            children: [
              SalesInformations(
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
                goal: 1000000,
                title: "Sales of the month" + "",
                totalSales: 0,
                leftButton: SetGoalButton(),
                rightButton: SectionsButton(),
                children: [Text("" + "Sales until now\nR\$ 165.059,04")],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

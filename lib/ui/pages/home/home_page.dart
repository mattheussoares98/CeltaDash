import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../main/factories/factories.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';

class HomePage extends StatelessWidget {
  final HomePresenter homePresenter;

  const HomePage(this.homePresenter, {super.key});

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      makeResumePage(),
      IndicatorsPage(),
      SalesPage(),
      ProductsPage(),
      makeTeamPage(),
    ];
    return StreamBuilder<int>(
      stream: homePresenter.currentPageIndexStream,
      builder: (context, snapshot) {
        return Scaffold(
          body: ListenableProvider(
            create: (_) => homePresenter,
            child: pages[snapshot.data ?? 0],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: snapshot.data ?? 0,
            onTap: homePresenter.updateSelectedIndex,
            type: BottomNavigationBarType.fixed,
            unselectedFontSize: 10,
            selectedFontSize: 12,
            selectedIconTheme: IconThemeData(
              size: 30,
              color: Theme.of(context).primaryColorDark,
            ),
            unselectedIconTheme: IconThemeData(
              size: 20,
              color: Theme.of(context).primaryColorLight,
            ),
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.pie_chart),
                label: R.string.resume,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart),
                label: R.string.indicators,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.monetization_on),
                label: R.string.sales,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart_rounded),
                label: R.string.products,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_pin_sharp),
                label: R.string.team,
              ),
            ],
          ),
        );
      },
    );
  }
}

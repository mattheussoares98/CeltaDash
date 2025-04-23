import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../main/factories/factories.dart';
import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';

class HomePage extends StatefulWidget {
  final HomePresenter homePresenter;

  const HomePage(this.homePresenter, {super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        await widget.homePresenter.getBsEnterprises(
            showBsErrorMessage: (error) {
          snackBarMessage(context, error, Colors.red);
        });
      }
    });
  }

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
      stream: widget.homePresenter.currentPageIndexStream,
      builder: (context, snapshot) {
        return Scaffold(
          body: ListenableProvider(
            create: (_) => widget.homePresenter,
            child: pages[snapshot.data ?? 0],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: snapshot.data ?? 0,
            onTap: widget.homePresenter.updateSelectedIndex,
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

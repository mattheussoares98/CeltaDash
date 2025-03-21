import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages.dart';

class HomePage extends StatelessWidget {
  final HomePresenter homePresenter;

  const HomePage(this.homePresenter, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListenableProvider(
        create: (_) => homePresenter,
        child: Center(child: Text("Home")),
      ),
      bottomNavigationBar: StreamBuilder<int>(
        stream: homePresenter.currentPageIndexStream,
        builder: (context, snapshot) {
          return BottomNavigationBar(
            currentIndex: snapshot.data ?? 0,
            onTap: homePresenter.updateSelectedIndex,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.pie_chart), label: '1'),
              BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: '2'),
              BottomNavigationBarItem(
                icon: Icon(Icons.monetization_on),
                label: '3',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart_rounded),
                label: '4',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_pin_sharp),
                label: '5',
              ),
            ],
          );
        },
      ),
    );
  }
}

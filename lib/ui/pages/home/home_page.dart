import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: Text("Home")),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.pie_chart), label: '1'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: '2'),
          BottomNavigationBarItem(icon: Icon(Icons.monetization_on), label: '3'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_rounded), label: '4'),
          BottomNavigationBarItem(icon: Icon(Icons.person_pin_sharp), label: '5'),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../components/components.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        onChangeDateOrEnterprise: () {
          debugPrint("Search products again");
        },
      ),
      body: Center(child: Text("Products")),
    );
  }
}

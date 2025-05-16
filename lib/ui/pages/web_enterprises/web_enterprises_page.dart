import 'package:flutter/material.dart';

import '../pages.dart';

class WebCustomersPage extends StatefulWidget {
  final WebEnterprisesPresenter presenter;
  const WebCustomersPage({super.key, required this.presenter});

  @override
  State<WebCustomersPage> createState() => _WebCustomersPageState();
}

class _WebCustomersPageState extends State<WebCustomersPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        await widget.presenter.getCustomers();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WEB ENTERPRISES PAGE"),
        actions: [
          IconButton(
            onPressed: () async {
              await widget.presenter.getCustomers();
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: Center(child: Text("WEB ENTERPRISES")),
    );
  }
}

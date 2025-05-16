import 'dart:async';

import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';
import '../../mixins/mixins.dart';
import '../pages.dart';

class WebCustomersPage extends StatefulWidget {
  final WebEnterprisesPresenter presenter;
  const WebCustomersPage({super.key, required this.presenter});

  @override
  State<WebCustomersPage> createState() => _WebCustomersPageState();
}

class _WebCustomersPageState extends State<WebCustomersPage>
    with LoadingManager, UIErrorManager {
  StreamSubscription? loadingSubscription;
  StreamSubscription? mainErrorSubscription;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        await widget.presenter.getEnterprises();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();

    loadingSubscription =
        handleLoading(context, widget.presenter.isLoadingStream);
    mainErrorSubscription =
        handleMainError(context, widget.presenter.mainErrorStream);

    return Scaffold(
      appBar: AppBar(
        title: Text("WEB ENTERPRISES PAGE"),
        actions: [
          IconButton(
            onPressed: () async {
              await widget.presenter.getEnterprises();
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: StreamBuilder<List<FirebaseEnterpriseViewModel>?>(
          stream: widget.presenter.enterprisesStream,
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Center(
                child: Text(R.string.empty),
              );
            }
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final enterprise = snapshot.data![index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: ElevatedButton(
                    onPressed: widget.presenter.goToEnterpriseDetails,
                    child: Row(
                      children: [
                        Expanded(child: Text("${enterprise.enterpriseName}")),
                        IconButton(
                          onPressed: widget.presenter.goToEnterpriseDetails,
                          icon: Icon(Icons.mode_rounded),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: widget.presenter.goToEnterpriseDetails,
        child: Icon(Icons.add),
      ),
    );
  }
}

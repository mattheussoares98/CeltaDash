import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/home/presentation/pages/components/components.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.child,
    required this.currentLocation,
  });

  final Widget child;
  final String currentLocation;

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: child,
      bottomNavigationBar: HomeBottomNavigation(
        currentLocation: currentLocation,
      ),
    );
  }
}

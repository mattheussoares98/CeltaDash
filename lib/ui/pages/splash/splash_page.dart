import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../pages.dart';

class SplashPage extends StatefulWidget {
  final SplashPresenter presenter;

  const SplashPage({super.key, required this.presenter});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController _opacityController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    widget.presenter.checkPageToGo(
      enterprisesManagerPresenter: Get.find<EnterprisesManagerPresenter>(),
    );

    _opacityController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
    _opacityAnimation =
        Tween<double>(begin: 0.3, end: 1.0).animate(_opacityController);
  }

  @override
  void dispose() {
    _opacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedBuilder(
          animation: Listenable.merge([_opacityController]),
          builder: (context, child) {
            return Opacity(
              opacity: _opacityAnimation.value,
              child: Image.asset(
                'lib/ui/assets/images/logoCeltaTransparente.png',
                key: const Key("loading"),
              ),
            );
          },
        ),
      ),
    );
  }
}

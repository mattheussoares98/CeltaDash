import 'package:flutter/material.dart';

import '../pages.dart';

abstract class SplashPresenter implements Listenable {
  Future<void> checkPageToGo({
    int durationInSeconds,
    required EnterprisesManagerPresenter enterprisesManagerPresenter,
  });
}

import 'package:flutter/material.dart';

abstract class SplashPresenter implements Listenable {
  Future<void> checkPageToGo({
    int durationInSeconds,
    required DateTime atualDate,
  });
}

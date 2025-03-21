import 'package:flutter/material.dart';

abstract class HomePresenter implements Listenable {
  Stream<int> get currentPageIndexStream;
  void updateSelectedIndex(int index);
}

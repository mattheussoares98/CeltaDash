import 'package:flutter/material.dart';

abstract class HomePresenter implements Listenable {
  Stream<int> get currentPageIndexStream;
  DateTime get selectedDate;
  void updateSelectedIndex(int index);
  void updateSelectedDate(DateTime date);
}

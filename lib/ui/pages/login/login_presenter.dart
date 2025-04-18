import 'package:flutter/material.dart';

abstract class LoginPresenter implements Listenable {
  Future<void> login({required String user, required String password});
}

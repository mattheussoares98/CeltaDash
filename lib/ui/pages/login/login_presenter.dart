import 'package:flutter/material.dart';

abstract class LoginPresenter implements Listenable {
  Future<void> login({required String email, required String password});
}

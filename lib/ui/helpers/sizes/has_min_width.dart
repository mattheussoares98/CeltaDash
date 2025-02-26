import 'package:flutter/material.dart';

bool hasMinWidth(BuildContext context) {
  return MediaQuery.of(context).size.width > 900;
}

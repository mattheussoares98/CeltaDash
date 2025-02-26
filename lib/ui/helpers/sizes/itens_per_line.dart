import 'package:flutter/material.dart';

int getItensPerLine(BuildContext context) {
  if (MediaQuery.of(context).size.width / 333 < 1) {
    return 1;
  } else {
    return (MediaQuery.of(context).size.width / 333).floor();
  }
}

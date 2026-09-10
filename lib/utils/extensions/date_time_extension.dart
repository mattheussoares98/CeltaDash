// ignore_for_file: constant_identifier_names

import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String formatDate([DateFormatType type = DateFormatType.ddMMyyyy]) {
    return DateFormat(type.pattern, 'pt_BR').format(this);
  }
}

enum DateFormatType {
  //TODO sort alphabetically
  EEE('EEE'),
  yM('yM'),
  yMd('yMd'),
  yMMM('yMMM'),
  yMMMMd('yMMMMd'),
  yMMMd('yMMMd'),
  yMMMEd('yMMMEd'),
  yMMMMEEEEd('yMMMMEEEEd'),
  yMdHm('yMdHm'),
  yyyy('yyyy'),
  yyyyMM('yyyy-MM'),
  Hm('Hm'),
  MM('MM'),
  MMM('MMM'),
  MMMM('MMMM'),
  MMyyyy('MM/yyyy'),
  Hms('Hms'),
  ddMMyyyy('dd/MM/yyyy'),
  ddMMyyyyHHmm('dd/MM/yyyy HH:mm'),
  ddMMyyyyHHmmss('dd/MM/yyyy HH:mm:ss'),
  ddMM('dd/MM');

  const DateFormatType(this.pattern);
  final String pattern;
}

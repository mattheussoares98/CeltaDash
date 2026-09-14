// ignore_for_file: constant_identifier_names

import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String formatDate([DateFormatType type = DateFormatType.ddMMyyyy]) {
    return DateFormat(type.pattern, 'pt_BR').format(this);
  }
}

enum DateFormatType {
  ddMM('dd/MM'),
  ddMMyyyy('dd/MM/yyyy'),
  ddMMyyyyHHmm('dd/MM/yyyy HH:mm'),
  ddMMyyyyHHmmss('dd/MM/yyyy HH:mm:ss'),
  EEE('EEE'),
  EEEE('EEEE'),
  Hm('Hm'),
  Hms('Hms'),
  MM('MM'),
  MMM('MMM'),
  MMMM('MMMM'),
  MMyyyy('MM/yyyy'),
  yM('yM'),
  yMd('yMd'),
  yMdHm('yMdHm'),
  yMMM('yMMM'),
  yMMMd('yMMMd'),
  yMMMEd('yMMMEd'),
  yMMMMd('yMMMMd'),
  yMMMMEEEEd('yMMMMEEEEd'),
  yyyy('yyyy'),
  yyyyMM('yyyy-MM');

  const DateFormatType(this.pattern);
  final String pattern;
}

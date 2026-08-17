// ignore_for_file: constant_identifier_names

import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String formatDate([DateFormatType type = DateFormatType.ddMMyyyy]) {
    return DateFormat(type.pattern).format(this);
  }
}

enum DateFormatType {
  yMd('yMd'),
  yMMMMd('yMMMMd'),
  yMMMd('yMMMd'),
  yMMMEd('yMMMEd'),
  yMMMMEEEEd('yMMMMEEEEd'),
  yMdHm('yMdHm'),
  Hm('Hm'),
  Hms('Hms'),
  ddMMyyyy('dd/MM/yyyy'),
  ddMMyyyyHHmm('dd/MM/yyyy HH:mm'),
  ddMMyyyyHHmmss('dd/MM/yyyy HH:mm:ss'),
  ddMM('dd/MM');

  const DateFormatType(this.pattern);
  final String pattern;
}

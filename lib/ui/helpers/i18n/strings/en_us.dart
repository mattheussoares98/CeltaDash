// ignore_for_file: annotate_overrides

import './translation.dart';

class EnUs implements Translation {
  String get msgInvalidField => "Invalid field";
  String get msgRequiredField => "Required field";
  String get msgVeryShortField => "Field very short";
  String get msgUnexpectedError => "An unexpected error was happened";
  String get msgWriteSomething => "Write something";

  String get close => "Close";
  String get dateNotUpdated => "Date not updated";
  String get no => "No";
  String get wait => "Wait...";
  String get yes => "Yes";
}

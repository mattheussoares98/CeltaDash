import 'package:get/get.dart';

mixin LastDateLoadedDataManager on GetxController {
  DateTime? _lastDateLoadedData;
  DateTime? get lastDateLoadedData => _lastDateLoadedData;
  set lastDateLoaded(DateTime? value) => _lastDateLoadedData = value;
}

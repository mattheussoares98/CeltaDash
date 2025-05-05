class HoursComparisonViewModel {
  late double value;
  late String hour;

  HoursComparisonViewModel({
    required this.value,
    required this.hour,
  }) {
    this.value = value;
    this.hour = "${hour.padLeft(2, '0')}:00 ~ ${hour.padLeft(2, '0')}:59";
  }
}

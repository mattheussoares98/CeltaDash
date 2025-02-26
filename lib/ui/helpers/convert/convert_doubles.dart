import '../../../ui/helpers/helpers.dart';

extension DoubleModifier on double {
  double roundAccordingBs() {
    double diff = (this * 100 % 10).toStringAsFixed(2).toDouble();

    if (diff > 5) {
      return ((this * 100).ceil() / 100);
    } else {
      return ((this * 100).floor() / 100);
    }
  }
}

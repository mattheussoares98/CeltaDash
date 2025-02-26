import '../helpers.dart';

class FormFieldValidations {
  FormFieldValidations._();

  static String? field({
    required String? value,
    required bool canBeNullOrEmpty,
    int? minLength,
  }) {
    if ((value == null || value.isEmpty) && !canBeNullOrEmpty) {
      return R.string.msgRequiredField;
    } else if ((value == null || value.isEmpty) && canBeNullOrEmpty) {
      return null;
    } else if (minLength != null && value!.length < minLength) {
      return R.string.msgVeryShortField;
    } else {
      return null;
    }
  }
}

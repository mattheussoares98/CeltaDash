mixin HelpersMixin {
  DateTime parseTime(String time) {
    final cleaned = time.replaceFirst(RegExp(r'\r?\n[\s\S]*$'), '');
    final parts = cleaned.split(':');
    final hour = int.parse(parts[0]);
    final minute = parts.length > 1 ? int.parse(parts[1]) : 0;
    return DateTime(0, 1, 1, hour, minute);
  }
}

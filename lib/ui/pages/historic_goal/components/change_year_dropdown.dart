import 'package:flutter/material.dart';

class ChangeYearDropdown extends StatelessWidget {
  final DateTime now;
  final int selectedYear;
  final bool isLoading;
  final Function(int?) onYearChanged;
  const ChangeYearDropdown({
    super.key,
    required this.now,
    required this.selectedYear,
    required this.isLoading,
    required this.onYearChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DropdownButton<int>(
          value: selectedYear,
          underline: const SizedBox(),
          icon: const Icon(Icons.arrow_drop_down),
          style: Theme.of(context).textTheme.bodyLarge,
          iconSize: 24,
          elevation: 16,
          borderRadius: BorderRadius.circular(5),
          dropdownColor: Theme.of(context).colorScheme.surface,
          focusColor: Theme.of(context).colorScheme.primary,
          hint: Text(selectedYear.toString()),
          items: List.generate(now.year - 2025 + 1, (index) {
            final year = 2025 + index;
            return DropdownMenuItem<int>(
              value: year,
              child: Text(year.toString()),
            );
          }),
          onChanged: isLoading ? null : onYearChanged,
        ),
        if (isLoading)
          const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 1),
            ),
          )
      ],
    );
  }
}

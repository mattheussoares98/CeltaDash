import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/utils/constants/constants.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectDateRangeAndSearchButton extends StatefulWidget {
  const SelectDateRangeAndSearchButton({
    super.key,
    required this.maximumDaysDifference,
    required this.onSearch,
    required this.isLoading,
  });

  final Duration maximumDaysDifference;
  final void Function(DateTime initialDate, DateTime finalDate) onSearch;
  final bool isLoading;

  @override
  State<SelectDateRangeAndSearchButton> createState() =>
      _SelectDateRangeAndSearchButtonState();
}

class _SelectDateRangeAndSearchButtonState
    extends State<SelectDateRangeAndSearchButton> {
  static const _maximumPastPeriod = Duration(days: 365 * 5);

  late final DateTime _today;
  late DateTime _initialDate;
  late DateTime _finalDate;

  Duration get _maximumRange => widget.maximumDaysDifference;

  @override
  void initState() {
    super.initState();
    assert(widget.maximumDaysDifference.inDays > 0);
    _today = DateTime.now();
    _initialDate = _today.subtract(_maximumRange);
    _finalDate = _today;
  }

  @override
  void didUpdateWidget(covariant SelectDateRangeAndSearchButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.maximumDaysDifference == widget.maximumDaysDifference) return;

    _adjustFinalDateToRange();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(
          child: PrimaryButton(
            text: 'Início '.hardcoded + _initialDate.formatDate(),
            onPressed: widget.isLoading ? null : _selectInitialDate,
          ),
        ),
        gapW12,
        Flexible(
          child: PrimaryButton(
            text: 'Fim '.hardcoded + _finalDate.formatDate(),
            onPressed: widget.isLoading ? null : _selectFinalDate,
          ),
        ),
        IconButton(
          icon: const PlatformIcon(
            materialIcon: Icons.search,
            cupertinoIcon: CupertinoIcons.search,
          ),
          onPressed: widget.isLoading
              ? null
              : () => widget.onSearch(_initialDate, _finalDate),
        ),
      ],
    );
  }

  Future<void> _selectInitialDate() async {
    final newDate = await GetNewDate.get(
      currentSelectedDate: _initialDate,
      minimumDate: _today.subtract(_maximumPastPeriod),
      maximumDate: _today,
      insertHoursAndMinutes: false,
      context: context,
    );

    if (newDate == null || !mounted) return;

    setState(() {
      _initialDate = newDate;
      _adjustFinalDateToRange();
    });
  }

  Future<void> _selectFinalDate() async {
    final maximumDateForRange = _initialDate.add(_maximumRange);
    final maximumDate = maximumDateForRange.isAfter(_today)
        ? _today
        : maximumDateForRange;
    final newDate = await GetNewDate.get(
      currentSelectedDate: _finalDate,
      minimumDate: _initialDate,
      maximumDate: maximumDate,
      insertHoursAndMinutes: false,
      context: context,
    );

    if (newDate == null || !mounted) return;

    setState(() => _finalDate = newDate);
  }

  void _adjustFinalDateToRange() {
    final maximumFinalDate = _initialDate.add(_maximumRange);
    if (_finalDate.isBefore(_initialDate) ||
        _finalDate.isAfter(maximumFinalDate)) {
      _finalDate = maximumFinalDate.isAfter(_today) ? _today : maximumFinalDate;
    }
  }
}

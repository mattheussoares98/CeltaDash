import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';

class PeriodItems extends StatefulWidget {
  const PeriodItems({super.key});

  @override
  State<PeriodItems> createState() => _PeriodItemsState();
}

class _PeriodItemsState extends State<PeriodItems> {
  int selectedPeriod = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Theme.of(context).primaryColorLight.withAlpha(50),
          
        ),
      ),
      child: Row(
        children: [
          _PeriodItem(
            changeSelectedIndex: () {
              setState(() {
                selectedPeriod = 0;
              });
            },
            isSelected: selectedPeriod == 0,
            name: R.string.day,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
          ),
          _PeriodItem(
            border: Border.symmetric(
              vertical: BorderSide(
                color: Theme.of(context).primaryColorLight.withAlpha(50),
              ),
            ),
            changeSelectedIndex: () {
              setState(() {
                selectedPeriod = 1;
              });
            },
            isSelected: selectedPeriod == 1,
            name: R.string.month,
          ),
          _PeriodItem(
            changeSelectedIndex: () {
              setState(() {
                selectedPeriod = 2;
              });
            },
            isSelected: selectedPeriod == 2,
            name: R.string.year,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
        ],
      ),
    );
  }
}

class _PeriodItem extends StatelessWidget {
  final bool isSelected;
  final String name;
  final BorderRadiusGeometry? borderRadius;
  final void Function() changeSelectedIndex;
  final BoxBorder? border;
  const _PeriodItem({
    required this.isSelected,
    required this.name,
    required this.changeSelectedIndex,
    this.borderRadius,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: changeSelectedIndex,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            border: border,
            color:
                isSelected
                    ? Theme.of(context).primaryColorLight.withAlpha(60)
                    : null,
          ),
          child: Text(
            name,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

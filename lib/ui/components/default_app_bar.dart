import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'components.dart';

class DefaultAppBar extends StatefulWidget implements PreferredSizeWidget {
  final void Function() onChangeDateOrEnterprise;
  const DefaultAppBar({super.key, required this.onChangeDateOrEnterprise});

  static List<String> enterprises = [
    "Enterprise A",
    "Enterprise B",
    "Enterprise C",
    "Enterprise D",
  ];

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight);

  @override
  State<DefaultAppBar> createState() => _DefaultAppBarState();
}

double appBarHeight = 90;

class _DefaultAppBarState extends State<DefaultAppBar> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: appBarHeight,
      title: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: DefaultDropDown<String>(
                  onChanged: (_) {
                    widget.onChangeDateOrEnterprise();
                  },
                  hint: null,
                  items:
                      DefaultAppBar.enterprises
                          .map(
                            (e) => DropdownMenuItem<String>(
                              value: e,
                              alignment: Alignment.center,
                              child: Text(e),
                            ),
                          )
                          .toList(),
                  selectedItem: DefaultAppBar.enterprises[0],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: IconButton(onPressed: () {}, icon: Icon(Icons.settings)),
              ),
            ],
          ),
          SizedBox(height: 5),
          FittedBox(
            child: ElevatedButton.icon(
              onPressed: () async {
                final newDate = await GetNewDate.get(
                  reduceDaysFromInitialDate: 60,
                  canInsertDateBeforeNow: true,
                  insertHoursAndMinutes: false,
                  lastDate: DateTime.now(),
                );

                if (newDate != null) {
                  setState(() {
                    selectedDate = newDate;
                  });
                  widget.onChangeDateOrEnterprise();
                }
              },
              label: Text(
                "${DateFormat('dd/MM/yyyy').format(selectedDate)}  ${DateFormat('EEEE', 'pt_BR').format(selectedDate)}",
              ),
              icon: Icon(Icons.date_range, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

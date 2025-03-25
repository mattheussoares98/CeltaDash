import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../pages/pages.dart';
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
  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Provider.of(context, listen: false);

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
                    homePresenter.updateSelectedDate(newDate);
                  });
                  widget.onChangeDateOrEnterprise();
                }
              },
              label: Text(
                "${DateFormat('dd/MM/yyyy').format(homePresenter.selectedDate)}  ${DateFormat('EEEE', 'pt_BR').format(homePresenter.selectedDate)}",
              ),
              icon: Icon(Icons.date_range, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

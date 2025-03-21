import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../components/components.dart';

class HomeAppBar extends StatefulWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  static List<String> enterprises = [
    "Enterprise A",
    "Enterprise B",
    "Enterprise C",
    "Enterprise D",
  ];

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight);

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

double appBarHeight = 90;

class _HomeAppBarState extends State<HomeAppBar> {
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
                  onChanged: (_) {},
                  hint: null,
                  items:
                      HomeAppBar.enterprises
                          .map(
                            (e) => DropdownMenuItem<String>(
                              value: e,
                              alignment: Alignment.center,
                              child: Text(e),
                            ),
                          )
                          .toList(),
                  selectedItem: HomeAppBar.enterprises[0],
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
                }
              },
              label: Text("${DateFormat('dd/MM/yyyy').format(selectedDate)}  ${DateFormat('EEEE', 'pt_BR').format(selectedDate)}"),
              icon: Icon(Icons.date_range, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../components/components.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  static List<String> enterprises = [
    "Enterprise A",
    "Enterprise B",
    "Enterprise C",
    "Enterprise D",
  ];

  @override
  Size get preferredSize => const Size.fromHeight(85);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: preferredSize.height,
      title: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: DefaultDropDown<String>(
                  onChanged: (_) {},
                  hint: Text("Select an enterprise"),
                  items:
                      enterprises
                          .map(
                            (e) => DropdownMenuItem<String>(
                              value: e,
                              alignment: Alignment.center,
                              child: Text(e),
                            ),
                          )
                          .toList(),
                  selectedItem: enterprises[0],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: IconButton(onPressed: () {}, icon: Icon(Icons.settings)),
              ),
            ],
          ),
          FittedBox(child: Text("31/03/1998")),
        ],
      ),
    );
  }
}

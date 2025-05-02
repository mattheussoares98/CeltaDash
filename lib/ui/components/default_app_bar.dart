import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../helpers/helpers.dart';
import '../pages/pages.dart';
import 'components.dart';

class DefaultAppBar extends StatefulWidget implements PreferredSizeWidget {
  final void Function() onChangeDateOrEnterprise;
  const DefaultAppBar({super.key, required this.onChangeDateOrEnterprise});

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
      title: Obx(() {
        final enterprises = homePresenter.bsEnterprises;
        final selectedEnterprise = homePresenter.selectedEnterprise;

        if (enterprises == null) {
          return ElevatedButton(
            onPressed: () async {
              await homePresenter.getBsEnterprises(showBsErrorMessage: (error) {
                snackBarMessage(
                  context,
                  error,
                  Colors.red,
                );
              });
            },
            child: Text(R.string.loadEnterprises),
          );
        }
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: DefaultDropDown<EnterpriseViewModel?>(
                    onChanged: (e) {
                      if (e == homePresenter.selectedEnterprise) return;
                      homePresenter.updateSelectedEnterprise(e);
                      widget.onChangeDateOrEnterprise();
                    },
                    hint: null,
                    items: enterprises
                        .map(
                          (e) => DropdownMenuItem<EnterpriseViewModel?>(
                            value: e,
                            alignment: Alignment.center,
                            child: Text(
                              "${e.personalizedCode} - ${e.name}",
                              maxLines: 1,
                            ),
                          ),
                        )
                        .toList(),
                    selectedItem: selectedEnterprise,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: IconButton(
                      onPressed: () {
                        homePresenter.goToConfigurationsPage();
                      },
                      icon: Icon(Icons.settings)),
                ),
              ],
            ),
            SizedBox(height: 5),
            FittedBox(
              child: ElevatedButton.icon(
                onPressed: () async {
                  final newDate = await GetNewDate.get(
                    reduceDaysFromInitialDate: 1825,
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
        );
      }),
    );
  }
}

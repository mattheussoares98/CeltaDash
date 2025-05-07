import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../helpers/helpers.dart';
import '../pages/pages.dart';
import 'components.dart';

class DefaultAppBar extends StatefulWidget implements PreferredSizeWidget {
  final void Function(bool changedEnterprise) onChangeDateOrEnterprise;
  final void Function()? onTapRefresh;
  final void Function(DateTime newDate)? onChangeDate;
  final bool? showDatePicker;
  final bool? showEnterpriseDropdown;
  const DefaultAppBar({
    super.key,
    required this.onChangeDateOrEnterprise,
    this.showDatePicker = true,
    this.showEnterpriseDropdown = true,
    this.onTapRefresh,
    this.onChangeDate,
  });

  @override
  Size get preferredSize => Size.fromHeight(
      this.showDatePicker == true && this.showEnterpriseDropdown == true
          ? 90
          : 60);

  @override
  State<DefaultAppBar> createState() => _DefaultAppBarState();
}

class _DefaultAppBarState extends State<DefaultAppBar> {
  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Provider.of(context, listen: false);

    return AppBar(
      toolbarHeight:
          widget.showDatePicker == true && widget.showEnterpriseDropdown == true
              ? 90
              : 60,
      title: Obx(() {
        final enterprises = homePresenter.enterprises;
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
            if (widget.showEnterpriseDropdown == true)
              Row(
                children: [
                  Expanded(
                    child: DefaultDropDown<EnterpriseViewModel?>(
                      onChanged: (e) {
                        if (e == homePresenter.selectedEnterprise) return;
                        homePresenter.updateSelectedEnterprise(e);
                        widget.onChangeDateOrEnterprise(true);
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
            if (widget.showDatePicker == true)
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final newDate = await GetNewDate.get(
                          reduceDaysFromInitialDate: 1825,
                          canInsertDateBeforeNow: true,
                          insertHoursAndMinutes: false,
                          lastDate: DateTime.now(),
                        );

                        if (newDate != null &&
                            newDate != homePresenter.selectedDate) {
                          setState(() {
                            homePresenter.updateSelectedDate(newDate);
                          });
                          if (widget.onChangeDate != null) {
                            widget.onChangeDate!(newDate);
                          }
                        }
                      },
                      label: Text(
                        "${DateFormat('dd/MM/yyyy').format(homePresenter.selectedDate)}  ${DateFormat('EEEE', 'pt_BR').format(homePresenter.selectedDate)}",
                      ),
                      icon: Icon(Icons.date_range, color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: IconButton(
                      onPressed: widget.onTapRefresh,
                      icon: Icon(Icons.refresh),
                    ),
                  )
                ],
              ),
          ],
        );
      }),
    );
  }
}

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../main/builders/builders.dart';
import '../helpers/helpers.dart';
import '../pages/pages.dart';
import 'components.dart';

class DefaultAppBar extends StatefulWidget implements PreferredSizeWidget {
  final void Function(bool changedEnterprise) onChangeEnterprise;
  final void Function()? onTapRefresh;
  final void Function(DateTime newDate)? onChangeDate;
  final bool? showDatePicker;
  final bool? showEnterpriseDropdown;
  final bool? isLoading;
  final double datePickerHeight;
  final double paddingPattern;
  const DefaultAppBar({
    super.key,
    required this.onChangeEnterprise,
    this.showDatePicker = true,
    this.showEnterpriseDropdown = true,
    this.onTapRefresh,
    this.onChangeDate,
    this.isLoading,
    this.datePickerHeight = 30,
    this.paddingPattern = 20,
  });

  @override
  Size get preferredSize => Size.fromHeight(
      this.showDatePicker == true && this.showEnterpriseDropdown == true
          ? DropdownHeight.height + datePickerHeight + paddingPattern
          : DropdownHeight.height + paddingPattern);

  @override
  State<DefaultAppBar> createState() => _DefaultAppBarState();
}

class _DefaultAppBarState extends State<DefaultAppBar> {
  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Get.find();
    final isIOS = Platform.isIOS;

    return AppBar(
      backgroundColor: isIOS ? Colors.grey[100] : null,
      elevation: isIOS ? 0 : null,
      toolbarHeight:
          widget.showDatePicker == true && widget.showEnterpriseDropdown == true
              ? DropdownHeight.height +
                  widget.datePickerHeight +
                  widget.paddingPattern
              : DropdownHeight.height +
                  widget.paddingPattern +
                  widget.paddingPattern,
      title: Obx(() {
        final enterprises = homePresenter.enterprises;
        final selectedEnterprise = homePresenter.selectedEnterprise;

        if (enterprises == null) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  await homePresenter.getBsEnterprises(
                    docRef: FirebaseFirestore.instance
                        .collection("enterprises")
                        .doc(
                          EnterpriseBuilder.entity?.firebaseId,
                        ),
                    showBsErrorMessage: (error) {
                      snackBarMessage(
                        context,
                        error,
                        Colors.red,
                      );
                    },
                  );
                },
                child: Text(R.string.loadEnterprises),
              ),
            ],
          );
        }
        return Column(
          children: [
            if (widget.showEnterpriseDropdown == true)
              DefaultDropDown<EnterpriseViewModel?>(
                onChanged: widget.isLoading == true
                    ? null
                    : (e) {
                        if (e == homePresenter.selectedEnterprise) return;
                        homePresenter.updateSelectedEnterprise(e);
                        widget.onChangeEnterprise(true);
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
                label:
                    "${selectedEnterprise?.personalizedCode} - ${selectedEnterprise?.name}",
              ),
            if (widget.showDatePicker == true)
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: widget.isLoading == true
                          ? null
                          : () async {
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
                                  homePresenter.updateScreen();
                                  widget.onChangeDate!(newDate);
                                }
                              }
                            },
                      label: Text(
                        "${DateFormat('dd/MM/yyyy').format(homePresenter.selectedDate)}  ${DateFormat('EEEE', 'pt_BR').format(homePresenter.selectedDate)}",
                        maxLines: 1,
                      ),
                      icon: Icon(Icons.date_range, color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: IconButton(
                      onPressed:
                          widget.isLoading == true ? null : widget.onTapRefresh,
                      icon: widget.isLoading == true
                          ? SizedBox(
                              height: 25,
                              width: 25,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : Icon(
                              isIOS ? CupertinoIcons.refresh : Icons.refresh,
                              color: IsDarkTheme.isDark(context)
                                  ? Theme.of(context).primaryColorLight
                                  : Theme.of(context).primaryColorDark,
                            ),
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

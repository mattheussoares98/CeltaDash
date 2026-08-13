import 'dart:io';

import 'package:celta_dash/domain/helpers/helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../main/builders/builders.dart';
import '../../main/utils/utils.dart';
import '../helpers/helpers.dart';
import '../pages/pages.dart';
import 'components.dart';

class DefaultAppBar extends StatefulWidget implements PreferredSizeWidget {
  final void Function(bool changedEnterprise) onChangeEnterprise;
  final void Function(DateTime newDate)? onChangeDate;
  final bool? showDatePicker;
  final bool? showEnterpriseDropdown;
  final bool? isLoading;
  final bool? showEnterpriseManagerButton;
  final double datePickerHeight;
  final double paddingPattern;
  const DefaultAppBar({
    super.key,
    required this.onChangeEnterprise,
    this.showDatePicker = true,
    this.showEnterpriseDropdown = true,
    this.showEnterpriseManagerButton = false,
    this.onChangeDate,
    this.isLoading,
    this.datePickerHeight = 30,
    this.paddingPattern = 20,
  });

  Size get portraitHeight => Size.fromHeight(
      this.showDatePicker == true && this.showEnterpriseDropdown == true
          ? DropdownHeight.height + datePickerHeight + paddingPattern
          : DropdownHeight.height + paddingPattern);

  Size get landscapeHeight => const Size.fromHeight(DropdownHeight.height);

  @override
  Size get preferredSize =>
      MediaQuery.of(NavigatorKey.key.currentState!.context).orientation ==
              Orientation.landscape
          ? landscapeHeight
          : portraitHeight;

  @override
  State<DefaultAppBar> createState() => _DefaultAppBarState();
}

class _DefaultAppBarState extends State<DefaultAppBar> {
  bool enterpriseIsEnabled(EcEnterpriseViewModel enterprise) {
    final subEnterprises = EnterpriseBuilder.entity?.firebaseSubEnterprises;

    if (subEnterprises != null) {
      final index =
          subEnterprises.indexWhere((e) => e.id == enterprise.id?.toInt());
      return subEnterprises[index].enabled == true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Get.find();
    EnterprisesManagerPresenter enterprisesManagerPresenter = Get.find();
    final isIOS = !kIsWeb && Platform.isIOS;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return AppBar(
      elevation: isIOS ? 0 : null,
      actionsPadding: EdgeInsets.zero,
      toolbarHeight: isPortrait
          ? (widget.showDatePicker == true &&
                  widget.showEnterpriseDropdown == true
              ? DropdownHeight.height +
                  widget.datePickerHeight +
                  widget.paddingPattern
              : DropdownHeight.height +
                  widget.paddingPattern +
                  widget.paddingPattern)
          : DropdownHeight.height + widget.paddingPattern,
      title: Obx(() {
        final enterprises = homePresenter.enterprises;
        final selectedEnterprise = homePresenter.selectedEnterprise;

        if (enterprises == null) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: homePresenter.getBsEnterprises,
                  child: Text(R.string.loadEnterprises),
                ),
              ),
              if (widget.showEnterpriseManagerButton == true)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: IconButton(
                    onPressed: () {
                      EnterprisesManagerPage.openModalButtonEnterpriseSelection(
                          context, enterprisesManagerPresenter);
                    },
                    icon: Icon(
                      isIOS ? CupertinoIcons.person_add : Icons.manage_accounts,
                    ),
                  ),
                )
            ],
          );
        }
        return Column(
          children: [
            if (widget.showEnterpriseDropdown == true)
              Row(
                children: [
                  if (widget.showDatePicker == true && !isPortrait)
                    Expanded(
                      child: SelectDate(
                        onChangeDate: widget.onChangeDate,
                        isLoading: widget.isLoading,
                      ),
                    ),
                  Expanded(
                    child: DefaultDropDown<EcEnterpriseViewModel?>(
                      onChanged: (e) {
                        if (e == homePresenter.selectedEnterprise) return;
                        homePresenter.updateSelectedEnterprise(e);
                        widget.onChangeEnterprise(true);
                      },
                      hint: Text(
                          "${selectedEnterprise?.personalizedCode} - ${selectedEnterprise?.name}"),
                      items: enterprises.map(
                        (e) {
                          final enabled = enterpriseIsEnabled(e);
                          return DropdownMenuItem<EcEnterpriseViewModel?>(
                            value: e,
                            enabled: enabled,
                            onTap: enabled == false
                                ? null
                                : () {
                                    debugPrint("apertou");
                                  },
                            alignment: Alignment.center,
                            child: Text(
                              "${e.personalizedCode} - ${e.name}${enabled == true ? "" : " (${R.string.disabled})"}",
                              maxLines: 1,
                              style: TextStyle(
                                color: enabled
                                    ? Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.color
                                    : Colors.red,
                              ),
                            ),
                          );
                        },
                      ).toList(),
                      selectedItem: selectedEnterprise,
                      label:
                          "${selectedEnterprise?.personalizedCode} - ${selectedEnterprise?.name}",
                    ),
                  ),
                  if (widget.showEnterpriseManagerButton == true)
                    IconButton(
                      onPressed: () {
                        EnterprisesManagerPage
                            .openModalButtonEnterpriseSelection(
                                context, enterprisesManagerPresenter);
                      },
                      icon: Icon(
                        isIOS
                            ? CupertinoIcons.person_add
                            : Icons.manage_accounts,
                      ),
                    )
                ],
              ),
            if (widget.showDatePicker == true && isPortrait)
              SelectDate(
                onChangeDate: widget.onChangeDate,
                isLoading: widget.isLoading,
              ),
          ],
        );
      }),
    );
  }
}

class SelectDate extends StatefulWidget {
  final void Function(DateTime newDate)? onChangeDate;
  final bool? isLoading;
  const SelectDate({
    super.key,
    required this.onChangeDate,
    required this.isLoading,
  });

  @override
  State<SelectDate> createState() => _SelectDateState();
}

class _SelectDateState extends State<SelectDate> {
  @override
  Widget build(BuildContext context) {
    final homePresenter = Get.find<HomePresenter>();
    final isIOS = !kIsWeb && Platform.isIOS;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 7,
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
                        widget.onChangeDate!(newDate);
                      }
                    }
                  },
            label: Text(
              "${DateFormat('dd/MM/yyyy').format(homePresenter.selectedDate)}  ${DateFormat('EEEE', 'pt_BR').format(homePresenter.selectedDate)}",
              maxLines: 1,
            ),
            icon: const Icon(Icons.date_range, color: Colors.white),
          ),
        ),
        Flexible(
          flex: 3,
          child: Obx(() {
            return TextButton(
              onPressed: homePresenter.toggleAppMode,
              child: Column(
                children: [
                  Icon(
                    isIOS
                        ? CupertinoIcons.arrow_2_squarepath
                        : Icons.compare_arrows,
                    color: IsDarkTheme.isDark
                        ? Theme.of(context).primaryColorLight
                        : Theme.of(context).primaryColorDark,
                  ),
                  FittedBox(
                    child: Text(homePresenter.appMode == AppMode.financialTitles
                        ? R.string.financial
                        : R.string.sales),
                  ),
                ],
              ),
            );
          }),
        )
      ],
    );
  }
}

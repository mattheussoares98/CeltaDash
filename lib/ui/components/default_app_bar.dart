import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/entities.dart';
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
      title: StreamBuilder<List<BsEnterpriseEntity>?>(
          stream: homePresenter.bsEnterprisesStream,
          builder: (context, snapAllEnterprises) {
            if (snapAllEnterprises.data == null) {
              ElevatedButton(
                onPressed: () async {
                  await homePresenter.getBsEnterprises(
                      showBsErrorMessage: (error) {
                    snackBarMessage(
                      context,
                      error,
                      backgroundColor: Colors.red,
                    );
                  });
                },
                child: Text(R.string.loadEnterprises),
              );
            }
            return StreamBuilder<BsEnterpriseEntity?>(
                stream: homePresenter.bsSelectedEnterpriseStream,
                builder: (context, snapshot) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: DefaultDropDown<BsEnterpriseEntity?>(
                              onChanged: (_) {
                                widget.onChangeDateOrEnterprise();
                              },
                              hint: null,
                              items: snapAllEnterprises.data
                                  ?.map(
                                    (e) =>
                                        DropdownMenuItem<BsEnterpriseEntity?>(
                                      value: e,
                                      alignment: Alignment.center,
                                      child: Text(
                                        "${e.PersonalizedCode} - ${e.Name}",
                                        maxLines: 1,
                                      ),
                                    ),
                                  )
                                  .toList(),
                              selectedItem: snapshot.data,
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
                  );
                });
          }),
    );
  }
}

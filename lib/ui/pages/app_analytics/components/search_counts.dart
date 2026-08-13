import 'dart:io';

import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';
import '../view_models/view_models.dart';

class SearchCounts extends StatefulWidget {
  final MonthlyAnalyticsViewModel analytic;
  const SearchCounts({super.key, required this.analytic});

  @override
  State<SearchCounts> createState() => _SearchCountsState();
}

class _SearchCountsState extends State<SearchCounts> {
  bool requestAscending = true;
  bool orderTypeAscending = true;

  @override
  void initState() {
    super.initState();
    orderRequests();
  }

  void orderRequests() {
    if (requestAscending) {
      widget.analytic.searchCounts.sort(
        (a, b) =>
            b.countFormatted.toInt()!.compareTo(a.countFormatted.toInt()!),
      );
    } else {
      widget.analytic.searchCounts.sort(
        (a, b) =>
            a.countFormatted.toInt()!.compareTo(b.countFormatted.toInt()!),
      );
    }
    setState(() {
      requestAscending = !requestAscending;
    });
  }

  void orderTypes() {
    if (orderTypeAscending) {
      widget.analytic.searchCounts.sort((a, b) => b.title.compareTo(a.title));
    } else {
      widget.analytic.searchCounts.sort((a, b) => a.title.compareTo(b.title));
    }
    setState(() {
      orderTypeAscending = !orderTypeAscending;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.analytic.searchCounts.length,
          itemBuilder: (context, index) {
            final searchCount = widget.analytic.searchCounts[index];
            return Column(
              children: [
                if (index == 0)
                  Row(
                    children: [
                      Expanded(
                        flex: 35,
                        child: TextButton.icon(
                          onPressed: orderTypes,
                          icon: OrdenationIcon(ascending: orderTypeAscending),
                          label: FittedBox(
                            child: Text(
                              R.string.type,
                              textAlign: TextAlign.end,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 65,
                        child: TextButton.icon(
                          onPressed: orderRequests,
                          icon: OrdenationIcon(ascending: requestAscending),
                          label: FittedBox(
                            child: Text(
                              R.string.requests,
                              textAlign: TextAlign.end,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                Row(
                  children: [
                    Expanded(child: Text(searchCount.title)),
                    Text(
                      searchCount.countFormatted.toString(),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ],
            );
          },
        ),
        Row(
          children: [
            const Expanded(child: Text("")),
            Text(
              widget.analytic.totalSearchesFormatted,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class OrdenationIcon extends StatelessWidget {
  final bool ascending;
  const OrdenationIcon({super.key, required this.ascending});

  @override
  Widget build(BuildContext context) {
    final isIOS = !kIsWeb && Platform.isIOS;

    if (ascending) {
      return Icon(
        isIOS
            ? CupertinoIcons.arrow_up_circle_fill
            : Icons.arrow_upward_outlined,
      );
    } else {
      return Icon(
        isIOS
            ? CupertinoIcons.arrow_down_circle_fill
            : Icons.arrow_downward_outlined,
      );
    }
  }
}

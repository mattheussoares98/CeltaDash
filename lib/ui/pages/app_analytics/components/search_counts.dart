import 'dart:io';

import 'package:flutter/cupertino.dart';
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
      widget.analytic.searchCounts.sort((a, b) =>
          b.countFormatted.toInt().compareTo(a.countFormatted.toInt()));
    } else {
      widget.analytic.searchCounts.sort((a, b) =>
          a.countFormatted.toInt().compareTo(b.countFormatted.toInt()));
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

  IconData getIcon(bool ascending) {
    if (ascending) {
      return Platform.isIOS
          ? CupertinoIcons.arrow_up_circle_fill
          : Icons.sort_by_alpha;
    } else {
      return Platform.isIOS
          ? CupertinoIcons.arrow_down_circle_fill
          : Icons.sort_by_alpha;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
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
                        child: Row(
                          children: [
                            Text(
                              R.string.type,
                              style: theme.textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              onPressed: orderTypes,
                              icon: Icon(
                                getIcon(orderTypeAscending),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: orderRequests,
                            icon: Icon(
                              getIcon(requestAscending),
                            ),
                          ),
                          Text(
                            R.string.requests,
                            style: theme.textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
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
            Expanded(child: Text("")),
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

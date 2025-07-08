import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';
import '../view_models/view_models.dart';

class SearchCounts extends StatelessWidget {
  final MonthlyAnalyticsViewModel analytic;
  const SearchCounts({super.key, required this.analytic});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: analytic.searchCounts.length,
          itemBuilder: (context, index) {
            final searchCount = analytic.searchCounts[index];
            return Column(
              children: [
                if (index == 0)
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          R.string.type,
                          style: theme.textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        R.string.quantityAbbreviated,
                        style: theme.textTheme.titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
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
              analytic.totalSearchesFormatted,
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

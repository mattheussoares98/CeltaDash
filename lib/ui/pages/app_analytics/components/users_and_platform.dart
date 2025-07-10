import 'package:flutter/material.dart';

import '../view_models/view_models.dart';

class UsersAndPlatform extends StatelessWidget {
  final MonthlyAnalyticsViewModel analytic;
  const UsersAndPlatform({super.key, required this.analytic});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: analytic.users
          .map(
            (user) => Wrap(
              children: [
                Text(
                  user.userName,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Icon(user.platformIcon),
                const SizedBox(width: 20),
              ],
            ),
          )
          .toList(),
    );
  }
}

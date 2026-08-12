import 'package:flutter/material.dart';

import 'package:celta_dash/domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import 'app_analytics.dart'; // For the other models

class MonthlyAnalyticsModel extends MonthlyAnalyticsEntity {
  const MonthlyAnalyticsModel({
    required super.searchCounts,
    required super.users,
    required super.enterprise,
  });

  factory MonthlyAnalyticsModel.fromEntity(MonthlyAnalyticsEntity entity) {
    return MonthlyAnalyticsModel(
      searchCounts: entity.searchCounts
          .map((e) => SearchCountModel.fromEntity(e))
          .toList(),
      users: entity.users.map((e) => ActiveUserModel.fromEntity(e)).toList(),
      enterprise: entity.enterprise,
    );
  }

  // --- THIS IS THE ONLY CHANGED SECTION ---
  factory MonthlyAnalyticsModel.fromJson(
    Map<String, dynamic> json, {
    required String enterpriseId,
  }) {
    final List<SearchCountEntity> searchCountsList = [];
    final List<ActiveUserEntity> usersList = [];

    // Iterate over all keys in the JSON from Firestore
    json.forEach((key, value) {
      if (key == 'users') {
        // Handle the 'users' array separately
        if (value is List) {
          for (var userJson in value) {
            usersList.add(ActiveUserModel.fromJson(userJson));
          }
        }
      } else {
        // This key is a dynamic search count, e.g., "sales.daily"
        final parts = key.split('-');
        if (parts.length == 2 && value is int) {
          try {
            // Convert the string parts back into enums
            final reportType = ReportType.values.byName(parts[0]);
            final periodType = PeriodType.values.byName(parts[1]);

            searchCountsList.add(SearchCountEntity(
              reportType: reportType,
              periodType: periodType,
              count: value,
            ));
          } catch (e) {
            // Safely ignore keys that don't match our enum pattern
            // This prevents crashes if the data format changes
            debugPrint('Could not parse analytics key: $key');
          }
        }
      }
    });

    return MonthlyAnalyticsModel(
      searchCounts: searchCountsList,
      users: usersList,
      enterprise: enterpriseId,
    );
  }
  // --- END OF CHANGED SECTION ---

  // toJson is no longer used for writing to Firestore, but it's useful
  // for saving to local storage or for debugging.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    // Create the dynamic key-value pairs for search counts
    for (var searchCount in searchCounts) {
      final key =
          '${searchCount.reportType.name}-${searchCount.periodType.name}';
      data[key] = searchCount.count;
    }

    // Add the users array, converting each user to a JSON map
    data['users'] = users
        .map((user) => ActiveUserModel(
              userName: user.userName,
              platform: user.platform,
            ).toJson())
        .toList();

    return data;
  }

  MonthlyAnalyticsEntity toEntity() => MonthlyAnalyticsEntity(
        searchCounts: searchCounts,
        users: users,
        enterprise: enterprise,
      );
}

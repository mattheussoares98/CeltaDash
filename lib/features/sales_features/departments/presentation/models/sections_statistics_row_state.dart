// lib/features/departments/presentation/models/sections_statistics_row_state.dart
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SectionsStatisticsRowState extends Equatable {
  const SectionsStatisticsRowState({
    required this.department,
    required this.section,
    required this.sales,
    required this.cost,
    required this.profit,
    required this.margin,
    required this.share,
    required this.departmentColor,
  });

  final String department;
  final String section;
  final double sales;
  final double cost;
  final double profit;
  final double margin;
  final double share;
  final Color departmentColor;

  @override
  List<Object?> get props => [
    department,
    section,
    sales,
    cost,
    profit,
    margin,
    share,
    departmentColor,
  ];
}

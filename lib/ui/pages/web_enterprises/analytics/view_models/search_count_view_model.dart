import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

import '../../../../../domain/entities/entities.dart';

class SearchCountViewModel extends Equatable {
  final String title;
  final String countFormatted;

  const SearchCountViewModel({
    required this.title,
    required this.countFormatted,
  });

  factory SearchCountViewModel.fromEntity(SearchCountEntity entity) {
    String capitalize(String s) =>
        s.isNotEmpty ? s[0].toUpperCase() + s.substring(1) : '';
    final type = capitalize(entity.reportType.name);
    final period = capitalize(entity.periodType.name);

    return SearchCountViewModel(
      title: '$type ($period)',
      countFormatted: NumberFormat.compact().format(entity.count),
    );
  }

  @override
  List<Object?> get props => [title, countFormatted];
}

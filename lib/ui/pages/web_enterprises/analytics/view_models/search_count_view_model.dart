import 'package:equatable/equatable.dart';

import '../../../../../domain/entities/entities.dart';
import '../../../../../domain/helpers/helpers.dart';

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
    final type = capitalize(entity.reportType.description);
    final period = capitalize(entity.periodType.description);

    return SearchCountViewModel(
      title: '$type ($period)',
      countFormatted: entity.count.toString(),
    );
  }

  @override
  List<Object?> get props => [title, countFormatted];
}

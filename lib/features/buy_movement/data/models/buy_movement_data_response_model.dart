import 'package:celta_dash/features/buy_movement/data/models/models.dart';
import 'package:celta_dash/features/buy_movement/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class BuyMovementDataResponseModel extends Equatable {
  final SearchBuyMovementDataModel? searchParameters;
  final List<BuyMovementDataRowModel> results;

  const BuyMovementDataResponseModel({
    this.searchParameters,
    this.results = const [],
  });

  factory BuyMovementDataResponseModel.fromJson(Map json) {
    final searchParameters =
        (json['SearchParameters'] ?? json['searchParameters']) as Map?;
    final results = (json['Results'] ?? json['results']) as List?;

    return BuyMovementDataResponseModel(
      searchParameters: searchParameters == null
          ? null
          : SearchBuyMovementDataModel.fromJson(searchParameters),
      results:
          results
              ?.map(
                (result) =>
                    BuyMovementDataRowModel.fromJson(result as Map? ?? {}),
              )
              .toList() ??
          const [],
    );
  }

  factory BuyMovementDataResponseModel.fromEntity(
    BuyMovementDataResponseEntity entity,
  ) => BuyMovementDataResponseModel(
    searchParameters: entity.searchParameters == null
        ? null
        : SearchBuyMovementDataModel.fromEntity(entity.searchParameters!),
    results: entity.results.map(BuyMovementDataRowModel.fromEntity).toList(),
  );

  BuyMovementDataResponseEntity toEntity() => BuyMovementDataResponseEntity(
    searchParameters: searchParameters?.toEntity(),
    results: results.map((result) => result.toEntity()).toList(),
  );

  Map toJson() => {
    if (searchParameters != null)
      'SearchParameters': searchParameters!.toJson(),
    'Results': results.map((result) => result.toJson()).toList(),
  };

  @override
  List<Object?> get props => [searchParameters, results];
}

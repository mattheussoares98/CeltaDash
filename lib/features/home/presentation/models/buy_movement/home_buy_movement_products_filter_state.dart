import 'package:equatable/equatable.dart';

class HomeBuyMovementProductsFilterState extends Equatable {
  final String? productName;
  final int topCount;

  const HomeBuyMovementProductsFilterState({
    this.productName,
    this.topCount = 10,
  }) : assert(topCount > 0 && topCount <= 500);

  HomeBuyMovementProductsFilterState copyWith({
    String? productName,
    bool clearProductName = false,
    int? topCount,
  }) {
    return HomeBuyMovementProductsFilterState(
      productName: clearProductName ? null : productName ?? this.productName,
      topCount: topCount ?? this.topCount,
    );
  }

  @override
  List<Object?> get props => [productName, topCount];
}

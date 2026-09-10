import 'package:celta_dash/features/home/presentation/models/models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_buy_movement_products_filter_controller.g.dart';

@riverpod
class HomeBuyMovementProductsFilterController
    extends _$HomeBuyMovementProductsFilterController {
  @override
  HomeBuyMovementProductsFilterState build() {
    return const HomeBuyMovementProductsFilterState();
  }

  void setProductName(String value) {
    final productName = value.trim();
    state = state.copyWith(
      productName: productName,
      clearProductName: productName.isEmpty,
    );
  }

  void setTopCount(int value) {
    if (value < 1 || value > 500) {
      throw ArgumentError.value(value, 'value', 'Must be between 1 and 500.');
    }
    if (state.topCount == value) return;
    state = state.copyWith(topCount: value);
  }
}

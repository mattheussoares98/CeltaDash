import '../../../domain/entities/entities.dart';

extension SaleMovementsExtensions on List<SaleMovementEntity> {
  double totalByDay() => this.where((e) => e.Date != null).fold(
        0.0,
        (previousValue, element) => previousValue + (element.LiquidValue ?? 0),
      );
}

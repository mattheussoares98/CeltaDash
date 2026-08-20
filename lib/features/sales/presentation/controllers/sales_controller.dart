import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/domain/entities/entities.dart';
import 'package:celta_dash/features/home/home.dart' hide HomeSalesPeriod;
import 'package:celta_dash/features/sales/presentation/models/models.dart';
import 'package:celta_dash/features/sales/providers.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sales_controller.g.dart';

@riverpod
class SalesController extends _$SalesController {
  @override
  Future<SaleMovementEntity> build(
    int enterpriseId,
    SalesPeriod selectedPeriod,
  ) async {
    ref.cache();
    final ecParams = await ref.watch(
      activeEcParamsStateControllerProvider.future,
    );
    if (ecParams == null) {
      throw StateError('Não foi possível carregar os dados iniciais'.hardcoded);
    }
    final selectedDate = await ref.watch(
      homeControllerProvider.selectAsync((state) => state.selectedDate),
    );

    return ref
        .watch(salesRepositoryProvider)
        .getSaleMovements(
          params: _buildParams(
            enterpriseId: enterpriseId,
            selectedDate: selectedDate,
            selectedPeriod: selectedPeriod,
          ),
          ecParams: ecParams,
        );
  }

  GetSaleMovementParams _buildParams({
    required int enterpriseId,
    required DateTime selectedDate,
    required SalesPeriod selectedPeriod,
  }) {
    final startDate = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedPeriod == SalesPeriod.daily ? selectedDate.day : 1,
    );
    final endDate = selectedPeriod == SalesPeriod.daily
        ? startDate
        : DateTime(selectedDate.year, selectedDate.month + 1, 0);

    return GetSaleMovementParams(
      enterpriseIds: [enterpriseId],
      startDate: startDate,
      endDate: endDate,
      onlyCancelled: true,
    );
  }
}

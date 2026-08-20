import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/features/sales/domain/entities/entities.dart';
import 'package:celta_dash/features/sales/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sale_details_controller.g.dart';

@riverpod
class SaleDetailsController extends _$SaleDetailsController {
  @override
  Future<SaleMovementCollectionItemEntity> build(
    int enterpriseId,
    String documentNumber,
    DateTime billingDate,
  ) async {
    final date = DateTime(billingDate.year, billingDate.month, billingDate.day);
    final ecParams = await ref.watch(
      activeEcParamsStateControllerProvider.future,
    );
    if (ecParams == null) {
      throw StateError('Active enterprise credentials were not found.');
    }
    final result = await ref
        .watch(salesRepositoryProvider)
        .getSaleMovements(
          params: GetSaleMovementParams(
            documentNumbers: [documentNumber],
            enterpriseIds: [enterpriseId],
            startDate: date,
            endDate: date,
            mountCustomer: true,
            mountFiscalNoteType: true,
            mountProducts: true,
            mountSeller: true,
            mountPaymentFinalizations: true,
          ),
          ecParams: ecParams,
        );

    if (result.collection.isEmpty) {
      throw StateError('The selected sale was not found.');
    }
    return result.collection.first;
  }
}

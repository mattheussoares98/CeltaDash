// lib/features/home/presentation/controllers/personalized_controller.dart
import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/domain/helpers/helpers.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/features/sale_statistics/providers.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'personalized_controller.g.dart';

@riverpod
class PersonalizedController extends _$PersonalizedController {
  @override
  PersonalizedState build() {
    ref.cache();
    return PersonalizedState.initial();
  }

  void setDateRange(DateTime? startDate, DateTime? endDate) {
    state = state.copyWith(
      startDate: startDate ?? state.startDate,
      endDate: endDate ?? state.endDate,
      clearValidationError: true,
    );
  }

  void selectEnterprise(int enterpriseId) {
    state = state.copyWith(
      selectedEnterpriseId: enterpriseId,
      clearValidationError: true,
    );
  }

  void setPeriodGrouping(PeriodGroupingType? type) {
    if (type == null || state.periodGrouping == type) {
      state = state.copyWith(clearPeriodGrouping: true);
    } else {
      state = state.copyWith(periodGrouping: type);
    }
  }

  void toggleCategoryGrouping(CategoryGroupingType type) {
    final current = Set<CategoryGroupingType>.from(state.categoryGroupings);
    final isCurrentlySelected = current.contains(type);

    final next = <CategoryGroupingType>{};

    switch (type) {
      case CategoryGroupingType.product:
        if (!isCurrentlySelected) next.add(CategoryGroupingType.product);
        break;
      case CategoryGroupingType.cashierOperator:
        if (!isCurrentlySelected) {
          next.add(CategoryGroupingType.cashierOperator);
        }
        break;
      case CategoryGroupingType.seller:
        if (!isCurrentlySelected) next.add(CategoryGroupingType.seller);
        break;
      case CategoryGroupingType.paymentFinalization:
        if (!isCurrentlySelected) {
          next.add(CategoryGroupingType.paymentFinalization);
          if (current.contains(CategoryGroupingType.paymentModality)) {
            next.add(CategoryGroupingType.paymentModality);
          }
        } else {
          if (current.contains(CategoryGroupingType.paymentModality)) {
            next.add(CategoryGroupingType.paymentModality);
          }
        }
        break;
      case CategoryGroupingType.paymentModality:
        if (!isCurrentlySelected) {
          next.add(CategoryGroupingType.paymentModality);
          if (current.contains(CategoryGroupingType.paymentFinalization)) {
            next.add(CategoryGroupingType.paymentFinalization);
          }
        } else {
          if (current.contains(CategoryGroupingType.paymentFinalization)) {
            next.add(CategoryGroupingType.paymentFinalization);
          }
        }
        break;
      case CategoryGroupingType.productDepartment:
        if (!isCurrentlySelected) {
          next.add(CategoryGroupingType.productDepartment);
          if (current.contains(CategoryGroupingType.productSection)) {
            next.add(CategoryGroupingType.productSection);
          }
        } else {
          if (current.contains(CategoryGroupingType.productSection)) {
            next.add(CategoryGroupingType.productSection);
          }
        }
        break;
      case CategoryGroupingType.productSection:
        if (!isCurrentlySelected) {
          next.add(CategoryGroupingType.productSection);
          if (current.contains(CategoryGroupingType.productDepartment)) {
            next.add(CategoryGroupingType.productDepartment);
          }
        } else {
          if (current.contains(CategoryGroupingType.productDepartment)) {
            next.add(CategoryGroupingType.productDepartment);
          }
        }
        break;
    }

    state = state.copyWith(categoryGroupings: next);
  }

  void clearValidationError() {
    if (state.validationError != null) {
      state = state.copyWith(clearValidationError: true);
    }
  }

  Future<bool> generateReport() async {
    clearValidationError();

    if (state.startDate == null || state.endDate == null) {
      state = state.copyWith(validationError: 'Selecione o período.'.hardcoded);
      return false;
    }

    if (state.selectedEnterpriseId == null) {
      state = state.copyWith(validationError: 'Selecione a empresa.'.hardcoded);
      return false;
    }

    final start = DateTime(
      state.startDate!.year,
      state.startDate!.month,
      state.startDate!.day,
    );
    final end = DateTime(
      state.endDate!.year,
      state.endDate!.month,
      state.endDate!.day,
    );

    if (end.isBefore(start)) {
      state = state.copyWith(
        validationError:
            'A data final não pode ser anterior à data inicial.'.hardcoded,
      );
      return false;
    }

    final difference = end.difference(start).inDays;
    if (state.periodGrouping == PeriodGroupingType.hour && difference > 3) {
      state = state.copyWith(
        validationError:
            'Intervalo muito longo para agrupar por hora.'.hardcoded,
      );
      return false;
    }
    if (state.periodGrouping == PeriodGroupingType.day && difference > 60) {
      state = state.copyWith(
        validationError:
            'Intervalo muito longo para agrupar por dia.'.hardcoded,
      );
      return false;
    }
    if (state.periodGrouping == PeriodGroupingType.month && difference > 365) {
      state = state.copyWith(
        validationError:
            'Intervalo muito longo para agrupar por mês.'.hardcoded,
      );
      return false;
    }

    final params = state.buildParams();
    if (params == null) return false;

    final ecParams = await ref.read(
      activeEcParamsStateControllerProvider.future,
    );
    if (ecParams == null) {
      state = state.copyWith(
        sales: AsyncValue.error(
          Exception('Credenciais da empresa ativa não encontradas.'.hardcoded),
          StackTrace.current,
        ),
      );
      return false;
    }

    state = state.copyWith(
      sales: const AsyncValue.loading(),
      clearValidationError: true,
    );

    try {
      final repository = ref.read(saleStatisticsRepositoryProvider);
      final results = await repository.getSaleStatistics(
        params: params,
        ecParams: ecParams,
      );
      state = state.copyWith(
        sales: AsyncValue.data(results),
        lastLoadedParams: params,
      );
      return true;
    } catch (e, stackTrace) {
      state = state.copyWith(sales: AsyncValue.error(e, stackTrace));
      return false;
    }
  }
}

import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/features/home/presentation/controllers/home_controller.dart';
import 'package:celta_dash/features/home/presentation/models/models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_data_selection_controller.g.dart';

/// Exposes the active Home selection for a single application mode.
@riverpod
class HomeDataSelectionController extends _$HomeDataSelectionController {
  @override
  Future<HomeDataSelectionState?> build(AppMode appMode) {
    return ref.watch(
      homeControllerProvider.selectAsync((value) {
        final enterpriseId = value.selectedEnterpriseId;
        if (value.appMode != appMode || enterpriseId == null) return null;

        return HomeDataSelectionState(
          appMode: appMode,
          enterpriseId: enterpriseId,
          selectedDate: value.selectedDate,
        );
      }),
    );
  }
}

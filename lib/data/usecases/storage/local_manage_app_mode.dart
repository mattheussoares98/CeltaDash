import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../infra/helpers/helpers.dart';

class LocalManageAppMode implements ManageAppMode {
  final LocalStorage localStorage;

  LocalManageAppMode(this.localStorage);

  @override
  Future<AppMode> load() async {
    final selectedMode = await localStorage.get(DatabaseKeys.appMode);

    return AppMode.values.firstWhere(
      (mode) => mode.name == selectedMode,
      orElse: () => AppMode.sales,
    );
  }

  @override
  Future<void> change(AppMode mode) async {
    await localStorage.put(DatabaseKeys.appMode, mode.name);
  }
}

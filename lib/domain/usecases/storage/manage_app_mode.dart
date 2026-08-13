import '../../helpers/helpers.dart';

abstract class ManageAppMode {
  Future<AppMode> load();
  Future<void> change(AppMode mode);
}

import '../../entities/entities.dart';

abstract class LoadFinancialTitleData {
  Future<FinancialTitleDataResponseEntity> get(
    SearchFinancialTitleDataParams params, {
    String? url,
    String? userName,
    String? accessKey,
  });
}

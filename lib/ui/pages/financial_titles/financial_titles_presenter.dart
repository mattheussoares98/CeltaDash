import 'package:flutter/foundation.dart';

import '../../../domain/entities/entities.dart';
import 'financial_title_request_key.dart';
import 'financial_title_state.dart';

abstract class FinancialTitlesPresenter implements Listenable {
  FinancialTitleState stateOf(FinancialTitleRequestKey key);

  Stream<FinancialTitleState> streamOf(FinancialTitleRequestKey key);

  Future<void> load({
    required FinancialTitleRequestKey key,
    required SearchFinancialTitleDataParams params,
    bool forceRefresh = false,
  });

  void clear(FinancialTitleRequestKey key);
}

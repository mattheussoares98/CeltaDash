import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/financial_titles/financial_titles.dart';
import '../../factories.dart';

FinancialTitlesPresenter makeFinancialTitlesPresenter() =>
    GetxFinancialTitlesPresenter(
      loadFinancialTitleData: makeRemoteLoadFinancialTitleData(),
    );

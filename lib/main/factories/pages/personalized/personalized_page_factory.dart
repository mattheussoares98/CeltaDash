import '../../../../ui/pages/pages.dart';
import 'personalized.dart';

PersonalizedPage makePersonalizedPage() => PersonalizedPage(
      presenter: makeGetxPersonalizedPresenter(),
    );

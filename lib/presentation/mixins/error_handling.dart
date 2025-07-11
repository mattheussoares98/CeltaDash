import '../../domain/helpers/helpers.dart';
import '../../infra/helpers/helpers.dart';
import '../../ui/helpers/helpers.dart';

mixin ErrorHandling {
  UIError getUIError(dynamic error) {
    if (error is DomainError) {
      switch (error) {
        case DomainError.cannotRemoveSelectedEnterprise:
          return UIError.cannotRemoveSelectedEnterprise;
        case DomainError.enterpriseAlreadyExists:
          return UIError.enterpriseAlreadyExists;
        case DomainError.enterpriseNotFound:
          return UIError.enterpriseNotFound;
        case DomainError.sameDays:
          return UIError.sameDays;
        case DomainError.sameUrl:
          return UIError.sameUrl;
        case DomainError.unexpected:
          return UIError.unexpected;
        case DomainError.updateCeltaBs:
          return UIError.updateCeltaBs;
      }
    } else if (error is ApiError) {
      if (error.message.toString().toLowerCase() == '"invalid credentials"') {
        return UIError.custom(R.string.msgInvalidCredentials);
      }
      return UIError.custom(error.message);
    } else if (error is BsError) {
      return UIError.custom(error.message);
    }

    return UIError.unexpected;
  }
}

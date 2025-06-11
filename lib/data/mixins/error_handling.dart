import 'package:flutter/material.dart';

import '../../domain/helpers/helpers.dart';
import '../../infra/helpers/helpers.dart';
import '../http/http.dart';

mixin ErrorHandling {
  Never treatError(Object e) {
    debugPrint(e.toString());
    if (e is HttpError) {
      throw DomainError.unexpected;
    } else if (e is ApiError) {
      throw e; // Let it bubble up to be handled in the presenter
    } else if (e is BsError) {
      throw e; // Let it bubble up to be handled in the presenter
    } else if (e is DomainError) {
      throw e;
    }

    throw DomainError.unexpected;
  }
}

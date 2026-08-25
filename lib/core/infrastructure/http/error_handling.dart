import 'package:celta_dash/core/infrastructure/http/http.dart';
import 'package:celta_dash/domain/helpers/helpers.dart';
import 'package:celta_dash/infra/helpers/helpers.dart';
import 'package:flutter/material.dart';

mixin ErrorHandling {
  Never treatError(Object error) {
    debugPrint(error.toString());
    if (error is ApiError || error is BsError || error is DomainError) {
      throw error;
    }
    if (error is HttpError) {
      throw DomainError.unexpected;
    }
    throw DomainError.unexpected;
  }
}

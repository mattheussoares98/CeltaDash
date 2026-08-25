import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/exceptions/exceptions.dart';
import 'package:celta_dash/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

extension AsyncValueUI on AsyncValue {
  void showAlertDialogOnError(BuildContext context) {
    if (!isLoading && hasError) {
      showExceptionAlertDialog(
        context: context,
        title: 'Erro'.hardcoded,
        exception: parseErrorMessage(error!),
      );
    }
  }

  void doOnSuccess(
    AsyncValue<void>? previous,
    VoidCallback action, {
    bool previousMustBeLoading = true,
  }) {
    if ((!previousMustBeLoading || previous is AsyncLoading) &&
        !isLoading &&
        !hasError) {
      action();
    }
  }

  void showAlertDialogOnSuccess(
    BuildContext context, {
    required AsyncValue? previous,
    required String title,
    required String message,
  }) {
    if (previous is AsyncLoading && !isLoading && !hasError) {
      showAlertDialog(context: context, title: title, content: message);
    }
  }

  void showToastOnSuccess(
    BuildContext context, {
    required AsyncValue? previous,
    required String message,
  }) {
    if (previous != null && previous.isLoading && !isLoading && !hasError) {
      showToastMessage(message);
    }
  }

  void showToastOnError(BuildContext context, AsyncValue? previous) {
    if (previous != null && previous.isLoading && !isLoading && hasError) {
      showToastMessage(parseErrorMessage(error!), type: ToastType.error);
    }
  }
}

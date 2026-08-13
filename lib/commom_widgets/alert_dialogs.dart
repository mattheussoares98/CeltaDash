import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'commom_widgets.dart';

const kDialogDefaultKey = Key('dialog-default-key');

/// Generic function to show a platform-aware Material or Cupertino dialog
Future<bool?> showAlertDialog({
  required BuildContext context,
  required String title,
  String? content,
  Widget? contentWidget,
  String? cancelActionText,
  String defaultActionText = 'OK',
  VoidCallback? onOkPressed,
  List<Widget>? actions,
}) {
  return showDialog<bool>(
    context: context,
    // Only make the dialog dismissible if there is a cancel button
    barrierDismissible: cancelActionText != null,
    builder: (context) => AlertDialog.adaptive(
      key: kDialogDefaultKey,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: Text(title)),
          if (kDebugMode && (content?.isNotEmpty ?? false))
            IconButton(
              onPressed: () => Clipboard.setData(ClipboardData(text: content!)),
              icon: const PlatformIcon(
                cupertinoIcon: CupertinoIcons.doc_on_clipboard,
                materialIcon: Icons.copy,
              ),
            ),
        ],
      ),
      content:
          contentWidget ??
          (content != null
              ? SingleChildScrollView(child: Text(content))
              : null),
      actions:
          actions ??
          (PlatformUtil.isCupertino
              ? <Widget>[
                  if (cancelActionText != null)
                    CupertinoDialogAction(
                      child: Text(cancelActionText),
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                  CupertinoDialogAction(
                    child: Text(defaultActionText),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                      onOkPressed?.call();
                    },
                  ),
                ]
              : <Widget>[
                  if (cancelActionText != null)
                    TextButton(
                      child: Text(cancelActionText),
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                  TextButton(
                    child: Text(defaultActionText),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                      onOkPressed?.call();
                    },
                  ),
                ]),
    ),
  );
}

/// Generic function to show a platform-aware Material or Cupertino error dialog
Future<bool?> showExceptionAlertDialog({
  required BuildContext context,
  required String title,
  required dynamic exception,
}) => showAlertDialog(
  context: context,
  title: title,
  content: exception.toString(),
);

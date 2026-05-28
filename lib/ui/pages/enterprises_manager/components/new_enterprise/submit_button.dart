import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../helpers/helpers.dart';

class SubmitButton extends StatelessWidget {
  final void Function() onSubmit;
  const SubmitButton({super.key, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    final isIOS = !kIsWeb && Platform.isIOS;

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: ElevatedButton.icon(
        onPressed: onSubmit,
        icon: Icon(
          isIOS ? CupertinoIcons.add_circled : Icons.add_circle_outline,
        ),
        label: Text(R.string.addNewEnterprise),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

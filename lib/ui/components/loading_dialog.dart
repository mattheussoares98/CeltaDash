import '../helpers/helpers.dart';

import 'package:flutter/material.dart';

// import 'loading_image.dart';

void showLoading(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => PopScope(
      canPop: false,
      child: SimpleDialog(
        surfaceTintColor: Colors.white,
        children: <Widget>[
          Column(
            key: const Key("loading"),
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: loadingImage(),
              // ),
              // const SizedBox(height: 10),
              Text(R.string.wait.toUpperCase(), textAlign: TextAlign.center),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: LinearProgressIndicator(
                  backgroundColor: Colors.transparent,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

void hideLoading(BuildContext context) {
  if (Navigator.canPop(context)) {
    Navigator.of(context).pop();
  }
}

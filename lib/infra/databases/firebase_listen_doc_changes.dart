import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';

class FirebaseListenDocChanges extends StatefulWidget {
  final DocumentReference<Map<String, dynamic>> docRef;
  final Widget child;
  final Future<void> Function(Map<String, dynamic> data) function;
  const FirebaseListenDocChanges({
    required this.docRef,
    required this.child,
    required this.function,
    super.key,
  });

  @override
  State<FirebaseListenDocChanges> createState() =>
      _FirebaseListenDocChangesState();
}

class _FirebaseListenDocChangesState extends State<FirebaseListenDocChanges> {
  late Stream<DocumentSnapshot<Map<String, dynamic>>> stream;
  static bool _isLoading = false;
  static Map<String, dynamic>? _lastData;

  @override
  initState() {
    super.initState();

    stream = widget.docRef.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: stream,
      builder: (context, snapshot) {
        final data = snapshot.data?.data();

        Future.delayed(Duration.zero, () async {
          if (snapshot.hasData &&
              !_isLoading &&
              data != null &&
              !mapEquals(_lastData, data)) {
            _isLoading = true;
            await widget.function(data);
            _lastData = data;
            _isLoading = false;
          }
        });

        return widget.child;
      },
    );
  }
}

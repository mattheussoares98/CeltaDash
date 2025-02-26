import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../helpers/helpers.dart';
import 'components.dart';

class SearchWidget extends StatefulWidget {
  final Future<void> Function(bool useCamera) onPressSearch;
  final TextEditingController controller;
  final FocusNode focusNode;
  final String? hint;
  final String? label;
  final bool autofocus;
  final int? digitLimit;

  const SearchWidget({
    required this.autofocus,
    required this.controller,
    required this.onPressSearch,
    required this.focusNode,
    required this.label,
    required this.hint,
    this.digitLimit,
    super.key,
  });

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final _formKey = GlobalKey<FormState>();

  bool? _isValid() {
    return _formKey.currentState?.validate();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 0, 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Form(
              key: _formKey,
              child: TextFormField(
                focusNode: widget.focusNode,
                autofocus: widget.autofocus,
                controller: widget.controller,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(widget.digitLimit ?? 25),
                ],
                onChanged: (value) {
                  if (value.isEmpty || value == '-') {
                    value = '0';
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return widget.hint ?? R.string.msgWriteSomething;
                  } else {
                    return null;
                  }
                },
                decoration: FormFieldDecoration.decoration(
                  context: context,
                  labelText: widget.label,
                  prefixIcon: IconButton(
                    onPressed: () {
                      widget.controller.clear();

                      Future.delayed(Duration.zero, () {
                        FocusScope.of(context).unfocus();
                        FocusScope.of(context).requestFocus(widget.focusNode);
                      });
                    },
                    icon: const Icon(Icons.delete, color: Colors.red),
                  ),
                  hintText: widget.hint,
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: GestureDetector(
                            onTap: () async {
                              if (_isValid() != true) {
                                return;
                              }
                              FocusScope.of(context).unfocus();

                              await widget.onPressSearch(false);
                            },
                            child: Icon(
                              Icons.search,
                              size: 35,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        if (Platform.isIOS || Platform.isAndroid)
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: GestureDetector(
                                onTap: () async {
                                  await widget.onPressSearch(true);
                                },
                                child: Icon(
                                  Icons.camera_alt,
                                  size: 40,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                onFieldSubmitted: (value) async {
                  if (_isValid() != true) {
                    Future.delayed(const Duration(), () {
                      FocusScope.of(context).requestFocus(widget.focusNode);
                    });
                    return;
                  }

                  await widget.onPressSearch(false);
                },
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

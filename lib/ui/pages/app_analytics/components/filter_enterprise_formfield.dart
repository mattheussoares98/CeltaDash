import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';

class FilterEnterpriseFormfield extends StatelessWidget {
  final TextEditingController filteredEnterpriseController;
  final FocusNode filteredEnterpriseFocusNode;
  final void Function() callSetState;
  const FilterEnterpriseFormfield({
    super.key,
    required this.filteredEnterpriseController,
    required this.filteredEnterpriseFocusNode,
    required this.callSetState,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: filteredEnterpriseController,
        focusNode: filteredEnterpriseFocusNode,
        decoration: InputDecoration(
          labelText: R.string.filter,
          prefixIcon: Icon(
            theme.platform == TargetPlatform.iOS
                ? CupertinoIcons.search
                : Icons.search,
          ),
          suffixIcon: IconButton(
            onPressed: filteredEnterpriseController.text.isEmpty
                ? null
                : () {
                    filteredEnterpriseController.clear();
                    filteredEnterpriseFocusNode.requestFocus();
                    callSetState();
                  },
            icon: Icon(
              theme.platform == TargetPlatform.iOS
                  ? CupertinoIcons.clear_circled
                  : Icons.clear,
              color: filteredEnterpriseController.text.isEmpty
                  ? theme.disabledColor
                  : Colors.red,
            ),
          ),
        ),
        onChanged: (_) {
          callSetState();
        },
      ),
    );
  }
}

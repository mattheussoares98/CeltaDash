import 'package:celta_dash/presentation/protocols/protocols.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../main/composites/composites.dart';
import '../../../../validation/validators/validators.dart';
import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class FilterNotCanceledSales extends StatefulWidget {
  final bool isLoading;
  final bool alreadySearched;
  final VoidCallback onSearch;
  const FilterNotCanceledSales({
    super.key,
    required this.isLoading,
    required this.alreadySearched,
    required this.onSearch,
  });

  @override
  State<FilterNotCanceledSales> createState() => _FilterNotCanceledSalesState();
}

class _FilterNotCanceledSalesState extends State<FilterNotCanceledSales> {
  DateTime? selectedDate;
  final documentNumberController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    documentNumberController.dispose();
    super.dispose();
  }

  Future<void> _submit(BsSalesPresenter presenter) async {
    if (formKey.currentState?.validate() != true) {
      return;
    }
    if (selectedDate == null) {
      snackBarMessage(
        context,
        R.string.msgSelectDate,
        Colors.red,
      );
      return;
    }

    await presenter.getNotCanceledSales(
      documentNumbers: [documentNumberController.text],
      date: selectedDate!,
    );

    widget.onSearch.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final bsSalesPresenter = Get.find<BsSalesPresenter>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: Row(
        children: [
          TextButton(
            onPressed: widget.isLoading
                ? null
                : () async {
                    final date = await GetNewDate.get(
                      canInsertDateBeforeNow: true,
                      insertHoursAndMinutes: false,
                      lastDate: now,
                      reduceDaysFromInitialDate: 365 * 3,
                    );

                    if (date != null) {
                      setState(() {
                        selectedDate = date;
                      });
                    }
                  },
            child: FittedBox(
              child: Text(
                selectedDate == null
                    ? R.string.date
                    : DateFormat.yMd('pt_BR').format(selectedDate!),
              ),
            ),
          ),
          Expanded(
            child: Form(
              key: formKey,
              child: TextFormField(
                controller: documentNumberController,
                maxLength: 10,
                enabled: widget.isLoading == false,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: false),
                onFieldSubmitted: (_) {
                  _submit(bsSalesPresenter);
                },
                validator: (value) => ValidationComposite([
                  const NumberFieldValidation(onlyInt: true),
                ]).validate(value)?.description,
                decoration: FormFieldDecoration.decoration(
                  context: context,
                  labelText:
                      "${R.string.coupon} (${R.string.optional.toLowerCase()})",
                  hintText: R.string.coupon,
                ),
              ),
            ),
          ),
          FittedBox(
            child: IconButton(
              onPressed: widget.isLoading
                  ? null
                  : () async {
                      await _submit(bsSalesPresenter);
                    },
              icon: Icon(
                theme.platform == TargetPlatform.iOS
                    ? CupertinoIcons.search
                    : Icons.search,
              ),
            ),
          )
        ],
      ),
    );
  }
}

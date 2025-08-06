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
  final DateTime? selectedDate;
  final void Function(DateTime date) onChangeDate;
  const FilterNotCanceledSales({
    super.key,
    required this.isLoading,
    required this.alreadySearched,
    required this.onSearch,
    required this.selectedDate,
    required this.onChangeDate,
  });

  @override
  State<FilterNotCanceledSales> createState() => _FilterNotCanceledSalesState();
}

class _FilterNotCanceledSalesState extends State<FilterNotCanceledSales> {
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
    if (widget.selectedDate == null) {
      snackBarMessage(
        context,
        R.string.msgSelectDate,
        Colors.red,
      );
      return;
    }

    bool succeeds = await presenter.getNotCanceledSales(
      documentNumbers: [documentNumberController.text],
      date: widget.selectedDate!,
    );

    if (succeeds) {
      documentNumberController.clear();
    }

    widget.onSearch.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
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
                        widget.onChangeDate(date);
                      });
                      Future.delayed(const Duration(milliseconds: 100), () {
                        _submit(bsSalesPresenter);
                      });
                    }
                  },
            child: FittedBox(
              child: Text(
                widget.selectedDate == null
                    ? R.string.date
                    : DateFormat.yMd('pt_BR').format(widget.selectedDate!),
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
                  suffixIcon: mediaQuery.size.width < 300
                      ? null
                      : IconButton(
                          onPressed: documentNumberController.clear,
                          icon: Icon(
                            theme.platform == TargetPlatform.iOS
                                ? CupertinoIcons.clear
                                : Icons.clear,
                            color: Colors.red,
                          ),
                        ),
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
              icon: widget.isLoading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 1,
                      ),
                    )
                  : Icon(
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

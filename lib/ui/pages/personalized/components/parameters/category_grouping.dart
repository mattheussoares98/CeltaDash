import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../domain/helpers/helpers.dart';
import '../../../../../domain/usecases/usecases.dart';
import '../../../../helpers/helpers.dart';
import '../../../pages.dart';
import '../components.dart';

class CategoryGrouping extends StatefulWidget {
  final ExpansibleController categoriesController;
  final void Function(bool collapseParameters) collapseAll;
  const CategoryGrouping({
    super.key,
    required this.categoriesController,
    required this.collapseAll,
  });

  @override
  State<CategoryGrouping> createState() => _CategoryGroupingState();
}

class _CategoryGroupingState extends State<CategoryGrouping> {
  @override
  Widget build(BuildContext context) {
    final personalizedPresenter = Get.find<PersonalizedPresenter>();
    final selecteds =
        personalizedPresenter.currentSelectedParams?.selectedsCategories;

    return DefaultExpansionTile(
      controller: widget.categoriesController,
      title: RichText(
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          style: const TextStyle(
            color: Colors.black,
          ),
          children: [
            TextSpan(text: R.string.groupCategory),
            if (selecteds != null && selecteds.isNotEmpty)
              TextSpan(
                text: " (${selecteds.map((e) => e.name).join(', ')})",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
      children: CategoryGroupingType.values
          .map(
            (e) => InkWell(
              onTap: () {
                setState(() {
                  personalizedPresenter.changeCategoryGroupingType(e);
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(e.name),
                    ),
                    Checkbox(
                      value: selecteds?.contains(e),
                      onChanged: (_) {
                        setState(() {
                          personalizedPresenter.changeCategoryGroupingType(e);
                        });
                        widget.collapseAll(false);
                      },
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
